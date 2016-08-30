class UsersController < ApplicationController

    before_action	:authenticate_user!
    load_and_authorize_resource

    def index
        @users = User.order(name: :asc).eager_load(:feeds, :torrents)
        respond_to do |format|
            format.json do
                if can?(:manage, User)
                    render json: @users.as_json(only: [:id, :name, :feeds, :torrents])
                elsif can?(:index, User)
                    render json: @users.as_json(only: [:id, :name, :feeds, :torrents])
                else
                    render status: :unauthorized
                end
            end
            format.html do
                if can?(:manage, User)
                    render
                else
                    render status: :unauthorized
                end
            end
        end
    end

	def show
	end

    def manage
    end

    def approve
        @user.approve!
        render json: @user
    end

    def deny
        render json: !!@user.deny!
    end

    def update
        # update! do |success, failure|
        # 	success.json { render json: @user.to_json }
        # end
        respond_to do |format|
            if @user.update(user_params)
                format.json { render json: @user.to_json, status: :ok, location: @user }
            else
                format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
            end
        end
    end

    def destroy
		@user.destroy
        respond_to do |format|
            format.json { render json: @user.to_json }
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
            :name, :role, :approved, :admin
        )
    end
end
