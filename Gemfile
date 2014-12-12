source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '4.1.8'

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


# Better templating.
gem 'slim-rails'

# Local IP address -> coordinate geocoding.
gem 'geoip'

# gem 'paperclip'
gem 'friendly_id'
gem 'inherited_resources'
# gem 'acts-as-taggable-on'
gem 'bencode' # BitTorrent data serialation format support.
gem 'formtastic'
gem 'geocoder'
gem 'gravatar_image_tag'

# Use SCSS for stylesheets
gem 'sass-rails' , '~> 4.0.5'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier' , '>= 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'


group :test, :development do
  gem 'simplecov', :require => false
  gem 'sqlite3'
  # gem 'debugger'
  gem 'minitest'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
end


group :development do
  gem 'railroady'

  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails-console'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'

  gem 'byebug'
  # gem 'binding_of_caller'
  # gem 'better_errors'

  gem 'spring'
end

group :production do
  gem 'pg'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
