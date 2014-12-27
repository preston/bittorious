require 'digest/sha1'

class Peer < ActiveRecord::Base


	UPDATE_PERIOD_MINUTES = 5

	belongs_to :torrent, :foreign_key => 'info_hash', :primary_key => 'info_hash'
	belongs_to :user # For authenticated peers.

	# attr_accessible :downloaded, :info_hash, :ip, :left, :peer_id, :port, :state, :uploaded

	scope :seeds,	-> {where(:left => 0)}
	scope :peers,	-> {where('peers.left > 0')}
	scope :active,	-> {where("peers.state <> 'stopped' AND peers.updated_at > ?", UPDATE_PERIOD_MINUTES.minutes.ago)}

	geocoded_by :ip
	after_validation :geocode

	before_save :recalculate_affinity

	def recalculate_affinity
		if self.volunteer_enabled
			self.volunteer_affinity_offset = Digest::SHA1.hexdigest(self.torrent.info_hash) % self.torrent.pieces
			self.volunteer_affinity_length = (torrent.pieces * torrent.feed.replication_percentage / 100.0).ceil
		else
			self.volunteer_affinity_offset = 0
			self.volunteer_affinity_length = 0
	    	self.volunteer_disk_maximum_bytes = 0
    		self.volunteer_disk_used_bytes = 0
		end
	end
end
