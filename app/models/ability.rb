class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new # Unauthenticated
		cannot :manage, :all

		# The "/scrape" operation filters the torrent list internally based on authorizations for every torrent.
		can :scrape, Torrent


		# Anyone can read public public feeds.
		can :read,  Feed,		enable_public_archiving: true
		can [:index, :show, :announce],  Torrent, feed: {enable_public_archiving: true}
		can [:index, :read],	Peer,	torrent: {feed: {enable_public_archiving: true}}


		if user.id.nil?
			# Nada!
		elsif user.admin
			can :manage,	:all # Admins can do everything on every object!
		else
			# TODO REFACTOR: Needed for client-side role assignement.
			can :index, User

			# Feed subscriber permissions.
			can :read,    Feed,		permissions: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }
			can [:index, :transfer, :read, :announce], Torrent,	permissions: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }
			can :read, Peer,	torrent: {feed: { :user_id => user.id, role: Permission::SUBSCRIBER_ROLE }}

			# Feed publisher permissions.
			can [:read, :update, :grant], Feed,	permissions: { user_id: user.id, role: Permission::PUBLISHER_ROLE }
			can :manage,  Torrent,	feed: {permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }}
			can :manage,  Permission,	feed: {permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }}
			can :manage,  Peer,	torrent: {feed: {permissions: { :user_id => user.id, role: Permission::PUBLISHER_ROLE }}}

		end
	end
end
