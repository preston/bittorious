class TorrentsController < InheritedResources::Base
   

  respond_to :json, :html, :xml, :rss
  prepend_before_filter :set_params_from_torrent, :only => [:create]
  prepend_before_filter :load_from_info_hash

  skip_before_filter :authenticate_user!, only: [:announce, :scrape]
  before_filter :http_basic_authenticate, only: [:announce, :scrape]

  # load_and_authorize_resource

  # admin@example.com

  def http_basic_authenticate
    # user, pass = ActionController::HttpAuthentication::Basic::user_name_and_password(request)
    # puts "USER #{user}, PASS #{pass}."
    # request_http_basic_authentication
    authenticate_or_request_with_http_basic do |email, password|
      u = User.where(email: email).first
      ok = !u.nil? && u.valid_password?(password)
      # if ok
      #   warden.custom_failure! if performed?
      #   current_user = u
      # else
      #   request_http_basic_authentication
      # end
      ok
    end
  end

  def announce
    # authorize! :announce, :torrents
    resource.register_peer(peer_params)

    tracker_response = {'interval'    => 15.minutes,
                 'complete'   => resource.seed_count,
                 'incomplete' => resource.peer_count,
                 'peers'      => resource.peers.active.map{|p|  {'ip' => p.ip, 'peer id' => p.peer_id, 'port' => p.port}} }
    response.headers['Content-Type'] = 'text/plain; charset=ASCII'
    #force US-ASCII
    render :text => tracker_response.to_bencoding.encode('ASCII')
  end

  def create
    create! { dashboard_path }
  end

  def destroy
    destroy! { dashboard_path }
  end

  def update
    update! { dashboard_path }
  end

	def scrape
		# From http://wiki.theory.org/BitTorrentSpecification
		#   If info_hash was supplied and was valid, this dictionary will contain a single key/value. Each key consists of a 20-byte binary info_hash. The value of each entry is another dictionary containing the following:
		#
		#   complete: number of peers with the entire file, i.e. seeders (integer)
		#   downloaded: total number of times the tracker has registered a completion ("event=complete", i.e. a client finished downloading the torrent)
		#   incomplete: number of non-seeder peers, aka "leechers" (integer)
		#   name: (optional) the torrent's internal name, as specified by the "name" file in the info section of the .torrent file
		requested = []
		torrents = {}
		if(params[:info_hash] && t = load_from_info_hash)
			requested << t if t
		else
			requested = Torrent.all
		end
		requested.each do |t|
			torrents[t.private_info_hash] = {
				complete: t.seed_count,
				#downloaded: t.downloaded,
				incomplete: t.peer_count,
				name: t.name
			}
		end
		render text: {files: torrents}.bencode
	end

  def search
    tag = params[:q]
    @torrents = Torrent.all(:conditions => ['name LIKE ?', "%#{tag}%"])
    # FIXME Removing solr for now.
    # @torrents = Torrent.search do
    #   fulltext params[:q]
    # end.results
    render :json => {html: render_to_string('_search_results', :layout => false)}
  end

  def show
    respond_to do |format|
      format.html { render layout: false}
      format.torrent { send_file(resource.torrent_file.path(:bt))}
      # format.json { render :json => {:id => resource.id, :name => resource.name, :meta_html => render_to_string('_meta_data', :formats => :html, :layout => false, :locals => {:meta_data => resource.tracker.meta_data})}}
    end
  end

  def tags 
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @tags.map{|t| {:id => t.name, :label => t.name, :value => t.name }}}
    end
  end

  private
  def peer_params
    @peer_params ||= {
      info_hash:   params[:info_hash].unpack('H*').first,
      peer_id:     params[:peer_id].unpack('H*').first,
      remote_ip:   get_remote_ip, 
      uploaded:    params[:uploaded].to_i,
      downloaded:  params[:downloaded].to_i,
      left:        params[:left].to_i,
      key:         params[:key],
      event:       params[:event] || 'started',
      seed:        !!(@left == 0),
      rsize:       rsize,
      port:        params[:port]
    }
  end

  def rsize
    rsize = 50
    ['num want', 'numwant', 'num_want'].each do |k|
      if params[k]
        rsize = params[k].to_i
        break
      end
    end
  end

def set_params_from_torrent
  if !(request.params['torrent']['torrent_file'].blank?)
    torrent_params = request.params['torrent']
    b = 
      if torrent_params['torrent_file'].respond_to?(:path)
        BEncode.load_file(torrent_params['torrent_file'].path)
      else
        b64_file_contents = torrent_params['torrent_file'].read
        #set it back
        torrent_params['torrent_file'].rewind
        BEncode.load(b64_file_contents)
      end
    request.params['torrent']['info_hash'] = Digest::SHA1.hexdigest b["info"].bencode
    if torrent_params['name'].blank? && torrent_params['torrent_file'].respond_to?(:original_filename)
      request.params['torrent']['name'] = torrent_params['torrent_file'].original_filename.gsub(/\.torrent$/,'')
    end
  end
end


  def load_from_info_hash
    @torrent = Torrent.find_by_private_info_hash(params[:info_hash].unpack('H*').first) if params[:info_hash]
  end


  private


  # Use callbacks to share common setup or constraints between actions.
  def set_torrent
    @torrent = Torrent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def torrent_params
    params.require(:torrent).permit(
      :name, :slug, :torrent_file, :user, :user_id,
      :info_hash, :size, :tag_list, :feed, :feed_id, :private_info_hash)

  end

end
