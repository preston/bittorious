require 'digest/sha1'

class Peer < ActiveRecord::Base


	UPDATE_PERIOD_MINUTES = 5

	belongs_to :torrent
	belongs_to :user # For authenticated peers.

	# We'll allow tracking of non-registered torrents, for now.
	# validates_presence_of	:torrent

	scope :seeds,	-> {where(:left => 0)}
	scope :peers,	-> {where('peers.left > 0')}
	scope :active,	-> {where("peers.state <> 'stopped' AND peers.updated_at > ?", UPDATE_PERIOD_MINUTES.minutes.ago)}

	geocoded_by :ip
	after_validation :geocode

	before_save :recalculate_affinity

	def recalculate_affinity
		if self.volunteer_enabled
			if self.torrent.pieces <= 1
				self.volunteer_affinity_offset = 0
			else
				self.volunteer_affinity_offset = Digest::SHA256.hexdigest(self.peer_id).to_i(16) % (self.torrent.pieces - 1)
			end
			self.volunteer_affinity_length = (self.torrent.pieces * self.torrent.feed.replication_percentage / 100.0).ceil
		else
			self.volunteer_affinity_offset = 0
			self.volunteer_affinity_length = 0
	    	self.volunteer_disk_maximum_bytes = 0
    		self.volunteer_disk_used_bytes = 0
		end
		self
	end
end
