class FeedsController < InheritedResources::Base

  defaults resource_class: Feed.friendly

  before_filter :authenticate_user!, except: [:index, :template]

  load_and_authorize_resource

  respond_to :html, :json, :rss, :xml
  actions :update, :create, :destroy, :index, :edit


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
        f.can_manage = can?(:manage, f)
        # puts "CAN: #{can?(:manage, f)}"
        @feeds << f
      end
    end
    respond_to do |format|
      format.json {
        json = @feeds.to_json({
          include: [
            {torrents: {only: [:id, :name]}} #,
            # {permissions: { include: {user: { only: [:id, :name]}}}}
          ]
        })
        puts "JSON: #{json}"
        render json: json
      }
    end
  end

  def update
    update!{ dashboard_path }
  end

  def show
    respond_to do |format|
      format.json {
        json = @feed.to_json({include: [
          {user: { only: [:id, :name] }},
          {torrents: {}},
          {permissions: {}} # user: { only: [:id, :name, :email]}
        ]})
        # puts json
        render json: json
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
