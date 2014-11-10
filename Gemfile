source 'https://rubygems.org'
ruby '2.1.4'

gem 'rails', '4.1.7'

gem 'devise'
gem 'cancancan'

# General jQuery.
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'chosen-rails'
# gem 'rails3-jquery-autocomplete'
# gem 'bootstrap-tagsinput-rails'
# gem 'jquery-tablesorter'

# Twitter Bootstrap: https://github.com/seyhunak/twitter-bootstrap-rails
# gem 'therubyracer'
# gem 'less-rails'
gem 'twitter-bootstrap-rails'


# Better templating.
gem 'slim-rails'


# gem 'paperclip'
gem 'friendly_id'
gem 'inherited_resources'
# gem 'acts-as-taggable-on'
gem 'bencode' # BitTorrent data serialation format support.
gem 'formtastic'
gem 'geocoder'
gem 'gravatar_image_tag'

# Use SCSS for stylesheets
gem 'sass-rails' , '~> 4.0.3'
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
