require 'peer_reaper'
# require 'uri'
require 'open-uri'

namespace :bittorious do
    desc 'Reap old peers from the database.'
    task reap_peers: :environment do
        PeerReaper.reap_older_than(Peer::UPDATE_PERIOD_MINUTES.minutes.ago)
    end

    desc 'Downloads a fresh copy of the geolocation database.'
    task cache_geolocation: :environment do
        url = 'http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz'
        path = File.join(Rails.root, 'public', 'data', 'GeoLiteCity.dat')
        File.delete(path) if File.exist?(path)
        puts "Downloading #{url}..."
        data = open(url, 'rb') do |input|
            puts 'Decompressing...'
            data = Zlib::GzipReader.new(input).read
            puts "Writing to #{path}..."
            out = File.open path, 'wb'
            out.write data
            out.close
        end
        puts 'Done!'
    end
end
