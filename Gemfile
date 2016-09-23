source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails', '5.0.0.1'
# gem 'rails-html-sanitizer' # New in Rails 4.2

gem 'devise'
gem 'devise-bootstrap-views'
gem 'cancancan'

gem 'therubyracer' # Google v8 JavaScript runtime.

# AngularJS
# http://www.intridea.com/blog/2014/9/25/how-to-set-up-angular-with-rails
gem 'angular-rails-templates'
gem 'bower-rails'

# General jQuery.
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'chosen-rails'

gem 'bootstrap-sass'
gem 'autoprefixer-rails'

gem 'jbuilder'		# JSON output customization
gem 'slim-rails'	# Better templating.
gem 'geoip'			# Local IP address -> coordinate geocoding.

gem 'bencode'		# BitTorrent data serialation format support.
gem 'formtastic'
gem 'geocoder'
gem 'gravatar_image_tag'

gem	'puma'			# Better web server.

# Use SCSS for stylesheets
gem 'sass-rails' #, '~> 4.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' #, '>= 2.5.3'

gem 'pg'

group :test, :development do
  gem 'simplecov', require: false
  gem 'guard'
  gem 'guard-minitest', '2.4.5'
end


group :development do
  gem 'railroady'
  gem 'byebug'			# CLI debugging.
  gem 'web-console'		# Access an IRB console on exception pages or by using <%= console %> in views
  gem 'binding_of_caller'
  gem 'spring'
  gem 'yaml_db' # For dumping production data.
end

group :production do
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
