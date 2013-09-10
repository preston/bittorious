# Load the rails application
require File.expand_path('../application', __FILE__)
Mime::Type.register "application/x-bittorrent", :torrent
Mime::Type.register "application/rss+xml", :rss
# Initialize the rails application
Tater::Application.initialize!
