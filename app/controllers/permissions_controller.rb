class PermissionsController < InheritedResources::Base

	before_filter :authenticate_user!
	load_and_authorize_resource

	private 

  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def permission_params
    params.require(:permission).permit(
      # :feed_id, :user_id
      :role, :user, :feed)

  end

end
