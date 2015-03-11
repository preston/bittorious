BitTorious Server
=====

[![Build Status](https://travis-ci.org/preston/bittorious.svg?branch=master)](https://travis-ci.org/preston/bittorious)
[![GitHub version](https://badge.fury.io/gh/preston%2Fbittorious.svg)](http://badge.fury.io/gh/preston%2Fbittorious)
[![Code Climate](https://codeclimate.com/github/preston/bittorious/badges/gpa.svg)](https://codeclimate.com/github/preston/bittorious)

 * **Live Demo**: <http://try.bittorious.com>
 * **Recently published in _BMC Bioinformatics_**: <http://www.biomedcentral.com/1471-2105/15/424/abstract>
 * **Please deploy from an official release tag**! The _master_ branch is for active development and should be treated as _unstable_.

Have you ever wanted to distribute data by run you own private BitTorrent tracker and user management portal? Try BitTorious!

BitTorious is a sweet BitTorrent tracker and management portal for private groups. This project is a full fledged web application that allows for RSS feed grouping, user management, and role assignment into "publishers" and "subscriber" roles. All registrations must be approved by an adminstrator before being granted access to the system. Additionally, published torrents are re-written with the "private" flag set, by default, which prevents well-behaved clients from transmitting content to peers not authorized by your BitTorious tracker.

RSS feeds are provided for clients supporting feed polling. (We recommend <https://www.utorrent.com>)

Screenshots
--------

![Dashboard](https://raw.githubusercontent.com/preston/bittorious/master/app/assets/images/dashboard.png)
![Map](https://raw.githubusercontent.com/preston/bittorious/master/app/assets/images/map.png)
![Settings](https://raw.githubusercontent.com/preston/bittorious/master/app/assets/images/settings.png)
![Status](https://raw.githubusercontent.com/preston/bittorious/master/app/assets/images/status.png)
![Add](https://raw.githubusercontent.com/preston/bittorious/master/app/assets/images/add.png)
![RSS](https://raw.githubusercontent.com/preston/bittorious/master/app/assets/images/rss.png)

Features
--------
 * Integrated standards-compliant tracker.
 * Role-based administration. (Global admin, feed publishers, and feed subscribers.)
 * Supports both public and private torrents.
 * Token-based tracker authentication.
 * Real-time upload/download tracking.
 * Integration peer geolocation via Google Maps.
 * TLS/SSL-compatible. (Just bring your own certificate.) 
 * RESTful JSON API
 * RSS feeds are a first-class citizen
 * One-page dashboard for most users.

Development Quick Start
--------

BitTorious is written in Ruby, Rails, and AngularJS. It is primarily tested on PostgreSQL, but should work fine on most popular databases.

    bundle install
    rake bittorious:cache_geolocation # The geolocation data file is not included.
    rake db:migrate
    rake db:seed
    open http://localhost:3000 # Yay!
