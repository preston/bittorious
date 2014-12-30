class PeersController < InheritedResources::Base

	respond_to :json
	# load_resource :feed
	# load_resource :torrent, through: :feed

	skip_before_filter :authenticate_user!, only: [:index]
	layout false

	def index
		@torrent = Torrent.find(params[:torrent_id])
		authorize! :read, @torrent
		respond_to do |f|
			f.json { render json: @torrent.active_peers, include: {user: {only: [:id, :name]}} }
		end
	end

end