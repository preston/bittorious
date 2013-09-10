class Permission < ActiveRecord::Base

	belongs_to :feed
	belongs_to :user

	NO_ROLE = 'none'
	SUBSCRIBER_ROLE = 'subscriber'
	PUBLISHER_ROLE = 'publisher'

	attr_accessible :role, :user, :feed
	validates_presence_of :user, :feed

	attr_accessible :feed_id, :user_id

end
