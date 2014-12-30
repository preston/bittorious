class TrackerController < ApplicationController

	prepend_before_filter :load_from_info_hash
	skip_before_filter :authenticate_user!
	layout false

	def announce
		authorize! :announce, @torrent
		data = peer_params
		# puts "ANNOUNCE DATA: #{data}"
		peer = @torrent.register_peer(data, current_user)

		# This part is standard BitTorrent.
		tracker_response = {
			'interval'    => Peer::UPDATE_PERIOD_MINUTES.minutes,
			'complete'   => @torrent.seed_count,
			'incomplete' => @torrent.peer_count,
			'peers'      => @torrent.peers.active.map{|p|  {'ip' => p.ip, 'peer id' => p.peer_id, 'port' => p.port}}
		}

		# BitTorious-specific extensions.
		if peer.volunteer_enabled
			tracker_response['volunteer'] = {
				affinity_length: peer.affinity_length,
				affinity_offset: peer.affinity_offset
			}
		end

		response.headers['Content-Type'] = 'text/plain; charset=ASCII'
		render :text => tracker_response.to_bencoding.encode('ASCII') # Force US-ASCII
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
			authorize! :read, t
			requested << t if t
		elsif current_user
			requested = Torrent.accessible_by current_ability
		else # unauthenticated
			requested = Torrent.accessible_by Ability.new(nil)
		end
		requested.each do |t|
			torrents[t.info_hash] = {
				complete: t.seed_count,
				#downloaded: t.downloaded,
				incomplete: t.peer_count,
				name: t.name
			}
		end
		render text: {files: torrents}.bencode
	end

	
	private

	def load_from_info_hash
		@torrent = Torrent.find_by_info_hash(params[:info_hash].unpack('H*').first) if params[:info_hash]
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

	def peer_params
		# @peer_params ||=
		return {
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

end
