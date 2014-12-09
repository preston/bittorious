class PeerReaper
  def self.reap_older_than(time = Peer::UPDATE_PERIOD_MINUTES.minutes.ago)
    Peer.where('`peers`.`updated_at` < ?', time).destroy_all
  end
end