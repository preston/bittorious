class UsersController < InheritedResources::Base

	before_filter	:authenticate_user!
	load_and_authorize_resource
	respond_to :json

	def index
		authorize! :manage, User
		@users = User.order(name: :asc).eager_load(:feeds, :torrents)
		respond_to do |format|
			format.json
			format.html
		end
	end


	def manage
	end

	def approve
		@user.approve!
		render json: @user
	end

	def deny
		render json: !!(@user.deny!)
	end

	def update
		update! do |success, failure|
			success.json { render json: @user.to_json }
		end
	end

	def destroy
		destroy! do |success, failure|
			success.json { render json: @user.to_json }
		end
	end

	def transfer
		if @user.transfer_ownership(User.find(params[:user][:new_owner_id]))
			flash[:notice] = 'Ownership of torrents successfully transfered'
		else
			flash[:error] = @user.errors.full_messages
		end
		redirect_to edit_user_registration_path
	end


	private

	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
		params.require(:user).permit(
			:email, :password, :password_confirmation, :remember_me,
			:name, :role, :approved, :admin)
	end
	
end