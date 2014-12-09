class WelcomeController < ApplicationController
	
	before_filter :authenticate_user!, :only => [:dashboard, :status, :torrents]
	before_filter :set_selected_feed,	:only => [:dashboard]

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
