class PermissionsController < ApplicationController

  respond_to :json
  load_resource :feed # Need to load the feed before the permission resource is authorized.
  load_and_authorize_resource :permission, through: :feed, only: [:index, :destroy] # through: :feed,

  skip_before_action :authenticate_user!, only: [:index]

  layout false


  def index
    @feed = Feed.friendly.find(params[:feed_id])
    # authorize! :read, Permission
    @permissions = @feed.permissions.sort {|a,b| a.user.name <=> b.user.name}
    respond_to do |format|
      format.json { render json: @permissions, include: {user: {only: [:id, :name]}} }
    end
  end

  def show
	#   puts @permission
	respond_to do |format|
        format.json { render json: @permission }
	end
  end

  def create
    @feed = Feed.find(params[:feed_id])
    @permission = Permission.new(permission_params)
    @permission.feed = @feed
    authorize! :create, @feed.permissions.build
    respond_to do |format|
      format.json {
        if @permission.save
          AdminMailer.permission_grant(@permission).deliver_later
          render json: @permission, include: {user: {only: [:id, :name]}}
        else
          render json: {errors: @permission.errors}, status: :unauthorized
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def permission_params
    params.require(:permission).permit(
      :role, :feed_id, :user_id)
      # :role, :user, :feed)

  end

end
