class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new # guest user (not logged in)
		cannot :manage, :all
		cannot :approve, User
		cannot :deny, User

		# Anyone can read public (non-"private") torrents.
		can :read,  Feed,		enable_public_archiving: true
		can [:read, :announce],  Torrent,	feed: {enable_public_archiving: true}
		# can :announce,  Torrent,	feed: {enable_public_archiving: true}
		can [:index, :read],	Peer,	torrent: {feed: {enable_public_archiving: true}}

		# The "/scrape" operation filters the torrent list internally based on authorizations for every torrent.
		can :scrape, Torrent
	
		if user.id.nil?
		else # All logged in users
			# can :manage, User, :id => user.id
			# cannot :approve, User, :id => user.id
			# cannot :deny, User, :id => user.id
		end

		if user.admin
			can :manage,	:all # Can do every on every object!
		else
			# Non-admins.
			can :manage,  Feed,		permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }
			can :read,    Feed,		permissions: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }
			can :manage,  Torrent,	permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }
			can [:create, :destroy, :update, :show, :grant], Feed,	permissions: { user_id: user.id, role: Permission::PUBLISHER_ROLE }

			can [:transfer, :read, :scrape, :announce], Torrent,	permissions: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }
		end
	end
end
