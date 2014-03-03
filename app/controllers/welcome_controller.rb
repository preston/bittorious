class WelcomeController < ApplicationController
	
	before_filter :authenticate_user!, :only => [:dashboard, :status]
	before_filter :set_selected_feed,	:only => [:dashboard]

  def landing
  end

  def dashboard
    authorize! :read, Feed
    @feeds = Feed.order(:name).load
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
