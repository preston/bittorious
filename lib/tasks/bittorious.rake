require 'peer_reaper'

namespace :bittorious do

  desc "Reap old peers from the database."
  task :reap_peers => :environment do
    PeerReaper.reap_older_than(Peer::UPDATE_PERIOD_MINUTES.minutes.ago)
  end

end