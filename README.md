# BitTorious Server

_Note: Due to abuse of the public evaluation server, trial accounts on https://try.bittorious.com are no longer offered; however, The Cancer Imaging Archiving is evaluating a dedicated BitTorious instance at https://nih.bittorious.com that may be of interest. Pre-built Docker containers of versions v3.1.0 and later are available on [Docker Hub](https://hub.docker.com/r/p3000/bittorious), which is now the officially supported release method._

[![Build Status](https://travis-ci.org/preston/bittorious.svg?branch=master)](https://travis-ci.org/preston/bittorious)
[![GitHub version](https://badge.fury.io/gh/preston%2Fbittorious.svg)](http://badge.fury.io/gh/preston%2Fbittorious)
[![Code Climate](https://codeclimate.com/github/preston/bittorious/badges/gpa.svg)](https://codeclimate.com/github/preston/bittorious)

 * **Live Demo**: <http://try.bittorious.com>
 * **Recently published in _BMC Bioinformatics_**: <http://www.biomedcentral.com/1471-2105/15/424/abstract>
 * **Please deploy from an official release tag**! The _master_ branch is for active development and should be treated as _unstable_.

Have you ever wanted to distribute data by run you own private BitTorrent tracker and user management portal? Try BitTorious!

BitTorious is a sweet BitTorrent tracker and management portal for private groups. This project is a full fledged web application that allows for RSS feed grouping, user management, and role assignment into "publishers" and "subscriber" roles. All registrations must be approved by an administrator before being granted access to the system. Additionally, published torrents are re-written with the "private" flag set, by default, which prevents well-behaved clients from transmitting content to peers not authorized by your BitTorious tracker.

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

Deployment Using Docker
--------

As of v3.1, BitTorious is distributed on [Docker Hub](https://hub.docker.com/r/p3000/bittorious/). To download the "latest" tag:

	docker pull bittorious:latest

The BitTorious application is designed in [12factor](http://12factor.net) style and uses environment variables to inject your local configuration. You may optionally set these in your ~/.bash_profile, and reload your terminal.

	export BITTORIOUS_SECRET_KEY_BASE="used\_for\_cookie\_security"
	export BITTORIOUS_DATABASE_URL="postgres://bittorious:password@db.example.com:5432/bittorious_production" # Only used in "production" mode!
	export BITTORIOUS_DATABASE_URL_TEST="postgres://bittorious:password@db.example.com:5432/bittorious_test" # Only used in "test" mode!
	export BITTORIOUS_SMTP_HOST="smtp.example.com"
	export BITTORIOUS_SMTP_PORT="587"
	export BITTORIOUS_SMTP_USERNAME="jdoe"
	export BITTORIOUS_SMTP_PASSWORD="a_great_password"

  The following additional environment variables are optional, but potentially useful in a production context. Note that the database connection pool is adjusted automatically based on these values. If in doubt, do NOT set these.

	export BITTORIOUS_SERVER_PROCESSES=16 # To override the number of pre-forked workers.
	export BITTORIOUS_SERVER_THREAD=8 # To override the number of threads per process.

An example of running the container in production might look like:

	docker run -it --rm -p 3000:3000 \
		-e "BITTORIOUS_DATABASE_URL=postgres://bittorious:password@192.168.1.110:5432/bittorious_development" \
		-e "BITTORIOUS_SECRET_KEY_BASE=development_only" \
		-e "BITTORIOUS_SMTP_HOST=smtp.example.com" \
		-e "BITTORIOUS_SMTP_PORT=587" \
		-e "BITTORIOUS_SMTP_USERNAME=jdoe" \
		-e "BITTORIOUS_SMTP_PASSWORD=a_great_password" \
		p3000/bittorious:latest

To build your own container with local changes:

	docker build -t p3000/bittorious:latest .

Validate it against a separate test database like so:

	docker run -it --rm -p 3000:3000 \
		-e "RAILS_ENV=test" \
		-e "BITTORIOUS_DATABASE_URL_TEST=postgres://bittorious:password@192.168.110:5432/bittorious_test" \
		-e "BITTORIOUS_SECRET_KEY_BASE=development_only" \
		p3000/bittorious:latest rake test


Development Quick Start
--------

BitTorious is written in Ruby, Rails, and AngularJS. It is run and tested on PostgreSQL, but should work fine on most popular databases. It is built and deployed using Docker, and requires several environment variables to run. For developers running _outside_ of Docker:

	bundle install
	rake bittorious:cache_geolocation # The geolocation data file is not included.
	rake db:migrate
	rake db:seed
	open http://localhost:3000 # Yay!

To continually rerun regression tests as needed in the background as you develop, run guard in a separate terminal:

	guard
