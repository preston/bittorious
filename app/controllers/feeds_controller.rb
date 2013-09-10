class FeedsController < InheritedResources::Base

  before_filter :authenticate_user!
  before_filter :set_user_id, :only => [:create]
  load_and_authorize_resource
  respond_to :html, :json, :rss, :xml
  actions :update, :create, :destroy, :index

  def grant
    r = params[:user][:role]
    user = User.find(params[:user_id])
    puts "DDD: #{user.name}"
    perm = Permission.where(feed_id: @feed.id, user_id: user.id).first || Permission.new(feed_id: @feed.id, user_id: user.id)
    case r
    when Permission::NO_ROLE
      perm.destroy
    when Permission::PUBLISHER_ROLE
      perm.role = Permission::PUBLISHER_ROLE
      perm.save!
    when Permission::SUBSCRIBER_ROLE
      perm.role = Permission::SUBSCRIBER_ROLE
      perm.save!
    end

    render json: :head
  end


	def create
		create! do |format|
      format.html { redirect_to dashboard_path}
      format.json { render :json => @feed.to_json }
      format.xml { render :xml => @feed.to_xml }
    end
	end
	
	def destroy
		destroy! do |format|
      format.html { redirect_to dashboard_path}
      format.json { render :json => @feed.to_json }
    end
	end

  def index
    @feeds = current_user.feeds
    index!
  end

  def update
    update!{ dashboard_path }
  end

  def show
    respond_to do |format|
      format.json { render :json => {
          :id => resource.id,
          :name => resource.name,
          :publisher => resource.user.name,
          :torrent_html => render_to_string('welcome/_torrent_feed', :formats => :html, :layout => false, :locals => {:torrents => resource.torrents})
        }
      }
      format.any { render }
    end
  end

  private
  def set_user_id
    params[:feed][:user_id] = current_user.id
  end
end
