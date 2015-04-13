source 'https://rubygems.org'
ruby '2.2.1'

gem 'rails', '4.2.1'
# gem 'rails-html-sanitizer' # New in Rails 4.2

gem 'devise'
gem 'devise-bootstrap-views'
gem 'cancancan'

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

# JSON output customization
gem 'jbuilder'

# Better templating.
gem 'slim-rails'

# Local IP address -> coordinate geocoding.
gem 'geoip'

# gem 'paperclip'
gem 'friendly_id'
gem 'inherited_resources' #, github: 'josevalim/inherited_resources', branch: 'rails-4-2'
# gem 'acts-as-taggable-on'
gem 'bencode' # BitTorrent data serialation format support.
gem 'formtastic'
gem 'geocoder'
gem 'gravatar_image_tag'

# Use SCSS for stylesheets
gem 'sass-rails' , '~> 4.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' , '>= 2.5.3'


group :test, :development do
  gem 'simplecov', :require => false
  gem 'sqlite3'
  gem 'guard'
  gem 'guard-minitest'
end


group :development do
  gem 'railroady'

  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails-console'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'

  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'

  gem 'yaml_db' # For dumping production data.
end

group :production do
  gem 'pg'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
