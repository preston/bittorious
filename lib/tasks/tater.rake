require 'peer_reaper'
namespace :tater do
  desc "Reap peers older than 16 minutes"
  task :reap_peers => :environment do
    PeerReaper.reap_older_than(16.minutes.ago)
  end
end