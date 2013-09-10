class Peer < ActiveRecord::Base
  belongs_to :torrent, :foreign_key => 'info_hash', :primary_key => 'info_hash'
  attr_accessible :downloaded, :info_hash, :ip, :left, :peer_id, :port, :state, :uploaded

  scope :seeds, where(:left => 0)
  scope :peers, where('`peers`.`left` > 0')
  scope :active, where("`peers`.`state` <> 'stopped' AND `peers`.`updated_at` > ?", 16.minutes.ago)

  geocoded_by :ip
  after_validation :geocode
end
