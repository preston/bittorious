class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new # guest user (not logged in)
		cannot :manage, :all
		cannot :approve, User
		cannot :deny, User

		#all logged in users
		unless user.id.nil?
			can :manage, User, :id => user.id
			cannot :approve, User, :id => user.id
			cannot :deny, User, :id => user.id

			can :manage, Peer
		end

		if user.admin
			can :manage,	:all
			# can :approve,	User
			# can :deny,	User
			# can :manage,	Torrent
			# can :manage,	Permission
		else
			# Mere mortals.
			can :manage,  Feed,		permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }
			can :read,    Feed,		permissions: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }
			can :manage,  Torrent,	permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }
			can [:create, :destroy, :update, :show, :grant], Feed,	permissions: { user_id: user.id, role: Permission::PUBLISHER_ROLE }

			can [:transfer, :read, :screpe, :announce], Torrent,	permissions: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }
		end
	end
end
