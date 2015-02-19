class FeedsController < InheritedResources::Base

  defaults resource_class: Feed.friendly

  before_filter :allow_cors, only: [:index, :show]
  before_filter :authenticate_user!, except: [:index, :show]

  load_and_authorize_resource

  respond_to :html, :json, :rss #, :xml
  actions :update, :create, :destroy, :index, :edit

  INCLUDES = [
    {torrents: {only: [:id, :name]}} #,
            # {permissions: { include: {user: { only: [:id, :name]}}}}
  ]

	def create
    @feed = Feed.new(feed_params)
    @feed.user = current_user
    # @feed.torrents = 

    respond_to do |format|
      format.json {
        if @feed.save
          set_abilities @feed
          render :json => @feed.to_json({include: INCLUDES})
        else
          render json: {errors: @feed.errors}, status: :unprocessable_entity
        end
      }
    end
	end
	
	def destroy
    Feed.friendly.find(params[:id]).destroy!
    respond_to do |format|
      format.json { render :json => @feed.to_json }
    end
	end

  def index
    @feeds.each do |f|
      set_abilities f
    end
    respond_to do |format|
      format.json { render json: @feeds.to_json({include: INCLUDES}) }
    end
  end

  def update
    update! { dashboard_path }
  end

  def show
    authorize! :read, @feed
    respond_to do |format|
      format.json {
        json = @feed.to_json({include: INCLUDES})
        # puts json
        render json: json
      }
      format.rss { render }
    end
  end

  private

  def set_abilities(f)
    f.can_update = can?(:update, f)
    f.can_delete = can?(:delete, f)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feed_params
    params.require(:feed).permit(:name, :description, :slug, :permissions, :enable_public_archiving, :replication_percentage)
  end

end
