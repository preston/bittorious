class FeedsController < InheritedResources::Base

  defaults resource_class: Feed.friendly

  before_filter :authenticate_user!, except: [:index, :template]

  load_and_authorize_resource

  respond_to :html, :json, :rss, :xml
  actions :update, :create, :destroy, :index, :edit


  # def torrents
  # end
  
  # def settings
  #   respond_to do |format|
  #     format.html { render layout: false }
  #   end
  # end

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
    @feed = Feed.new(feed_params)
    @feed.user = current_user
		create! do |success, failure|
      success.html { redirect_to dashboard_path }
    end
	end
	
	def destroy
    Feed.friendly.find(params[:id]).destroy!
    # destroy! do |format|
    respond_to do |format|
      # format.html { redirect_to dashboard_path}
      format.json { render :json => @feed.to_json }
    end
	end

  def index
    @feeds = []
    Feed.order('LOWER(name) ASC').each do |f|
      if can? :read, f
        @feeds << f
      end
    end
    respond_to do |format|
      format.json { render json: @feeds, include: [{torrents: {only: [:id, :name]}}] }
    end
  end

  def update
    update!{ dashboard_path }
  end

  def show
    respond_to do |format|
      format.json {
        render json: @feed.to_json({include: [
          {user: { only: [:id, :name] }},
          {torrents: {}}
        ]})
      }
      format.rss { render }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feed_params
    params.require(:feed).permit(:name, :description, :slug, :permissions, :enable_public_archiving)
  end

end
