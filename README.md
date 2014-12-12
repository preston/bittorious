BitTorious Server
=====

BitTorious server is a bittorrent tracker that requires authentication for downloading, announcing and scraping.  BitTorious is a full fledged BT server that allows for tagging and searching of torrents as well as roles for users, publishers and administrators. All registrations must be approved for an adminstrator before being granted access to the system. Additionally, published torrents are re-written with the "private" flag set, which prevents, in normal cases, clients from transmitting content to peers not authorized by the tracker.

RSS feeds are all provided by clients supporting feed polling. 

Features
--------
*    Integrated Tracker
*    User roles
    *    Users
    *    Publishers
    *    Administrators
*    Private torrents
*    Authentication for tracker
    *    Username and Password
    *    Token
*    SSL
*    RESTful API
*    RSS for Feeds and All Torrents
*    Searchable Torrents By:
    *    Name
    *    Tags
    *    Torrent Filename
*    Dashboard
    *    List of Feeds
    *    Torrents by Feed
    *    List of Active Peers
    *    Google map of Peers
    *    Integrated Disqus for commenting

Development Quick Start
--------

    bundle install
    rake bittorious:cache_geolocation # The geolocation data file is not included.
    rake db:migrate
    rake db:seed
    open http://localhost:3000 # Yay!
