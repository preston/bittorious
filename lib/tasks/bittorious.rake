require 'peer_reaper'

namespace :bittorious do

  desc "Reap old peers from the database."
  task :reap_peers => :environment do
    PeerReaper.reap_older_than(Peer::UPDATE_PERIOD_MINUTES.minutes.ago)
  end

  desc "Downloads a fresh copy of the geolocation database."
  task :cache_geolocation do
	url = 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz'
	path = File.join(Rails.root, 'public', 'GeoLiteCity.dat')
	File.delete(path)
	puts "Downloading #{url}..."
  	data = open(url) { |io| io.read }
  	puts "Decompressing..."
	data = Zlib::GzipReader.new(data).read
	puts "Writing to disk..."
	File.open(path, 'wb')
	File.write data
	File.close
	puts "Done!"
  end

end