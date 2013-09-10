class PeerReaper
  def self.reap_older_than(time = 15.minutes.ago)
    Peer.where('`peers`.`updated_at` < ?', time).destroy_all
  end
end