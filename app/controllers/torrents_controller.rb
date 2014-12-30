class TorrentsController < InheritedResources::Base
   
  defaults resource_class: Torrent.friendly

  respond_to :json, :html, :xml, :rss
  prepend_before_filter :set_params_from_torrent, :only => [:create]

  load_resource :feed # Need to load the feed before the torrent resource is authorized.
  load_and_authorize_resource :torrent, except: [:show, :create] # through: :feed, 

  skip_before_filter :authenticate_user!, only: [:show, :index]

  layout false



  def create
    @torrent = Torrent.new(torrent_params)
    @torrent.user = current_user
    @torrent.data = request[:torrent][:file].read
    # @torrent.feed = @feed
    @feed = Feed.friendly.find(request[:feed_id]) # Must be set prior to metadata reprocessing.
    @torrent.feed = @feed
    authorize! :create, @feed.torrents.build

    @torrent.reprocess_meta
    respond_to do |format|
      format.json {
        if @torrent.save
          render json: @torrent, except: [:data]
        else
          render json: {errors: @torrent.errors}, except: [:data], status: :unprocessable_entity
        end
      }
    end
  end

  def index
    # FIXME Shouldn't cancancan do this automatically???
    authorize! :index, Feed.friendly.find(request[:feed_id])
    @torrents = Torrent.where(feed_id: params[:feed_id]).accessible_by(current_ability)

    respond_to do |f|
      f.json { render json: @torrents, include: [{user: {only: [:id, :name]}}], methods: [:seed_count, :peer_count], except: [:data] }
    end    
  end


  def show
    @torrent = Torrent.friendly.find(params[:id])
    # This is kinda weird, because it depends on the public/private nature of the feed.
    if(@torrent.feed.enable_public_archiving)
      # Go for it.
    else
      authorize! :show, @torrent
    end
    respond_to do |format|
      format.json { render json: resource, except: [:data], include: [{user: {only: [:id, :name]}}, :active_peers]}
      format.torrent { send_data(resource.data_for_user(current_user, announce_url))}
      # format.json { render :json => {:id => resource.id, :name => resource.name, :meta_html => render_to_string('_meta_data', :formats => :html, :layout => false, :locals => {:meta_data => resource.tracker.meta_data})}}
    end
  end

  private


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


  # Never trust parameters from the scary internet, only allow the white list through.
  def torrent_params
    params.require(:torrent).permit(
      :feed_id, :name, :file) #:user_id, :info_hash, :size, :feed_id, :private_info_hash)

  end

end
