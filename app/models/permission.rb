class Permission < ActiveRecord::Base

	belongs_to :feed
	belongs_to :user

	NO_ROLE = 'none'
	SUBSCRIBER_ROLE = 'subscriber'
	PUBLISHER_ROLE = 'publisher'

	validates_presence_of :user
	validates_presence_of :feed
	validates_uniqueness_of :user, scope: [:feed_id]

end
