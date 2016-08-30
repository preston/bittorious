class WelcomeController < ApplicationController
	
	before_action :authenticate_user!, :only => [:dashboard, :status, :torrents, :settings, :feeds]
	before_action :set_selected_feed,	:only => [:dashboard]

	def torrents
		render layout: false
	end

	def settings
		render layout: false
	end

	def feeds
		render layout: false
	end

	def landing
	end

	def dashboard
	end

	def concepts
	end

	def status
		authorize! :manage, :all #Peer
		respond_to do |format|
			format.json { render json: Peer.active.to_json(include: {torrent: {only: [:id, :name]}, user: {only: [:id, :name]} })  }
			format.html { render }
		end
	end

	def legal
	end

	def faq
	end

	private
	
	def set_selected_feed
		@selected_feed = nil
		if session[:selected_feed_id]
			@selected_feed = Feed.find(session[:selected_feed_id])
		end
		authorize! :read, @selected_feed if @selected_feed
		@selected_feed
	end

end
