class PermissionsController < InheritedResources::Base

	# before_filter :authenticate_user!
  # before_filter :set_feed
  # load_and_authorize_resource :feed
	# load_and_authorize_resource :permission, through: :feed

  respond_to :json
  load_resource :feed # Need to load the feed before the permission resource is authorized.
  load_and_authorize_resource :torrent, except: [:show, :create] # through: :feed, 

  skip_before_filter :authenticate_user!, only: [:index]

  layout false


  def index
    @feed = Feed.friendly.find(params[:feed_id])
    authorize! :read, @feed
    @permissions = @feed.permissions.sort {|a,b| a.user.name <=> b.user.name}
    respond_to do |format|
      format.json { render json: @permissions, include: {user: {only: [:id, :name]}} }
    end
  end

  def create
    @permission = Permission.new(permission_params)
    @permission.feed = @feed
    respond_to do |format|
      format.json {
        if @permission.save
          AdminMailer.permission_grant(@permission).deliver_later
          render json: @permission, include: {user: {only: [:id, :name]}}
        else
          render json: {errors: @permission.errors}, status: :unprocessable_entity
        end
      } 
    end
  end

  def destroy
    AdminMailer.permission_revoke(@permission).deliver_later
    @permission.destroy!
    respond_to do |format|
      format.json {
        render json: @permission.to_json
      }
    end
  end

	private 


  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def permission_params
    params.require(:permission).permit(
      :role, :feed_id, :user_id)
      # :role, :user, :feed)

  end

end
