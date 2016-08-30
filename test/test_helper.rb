ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/autorun'
# require 'minitest/pride'

require 'simplecov'
SimpleCov.start 'rails' do
	add_filter '/lib/'
 end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

	def json_response
    	ActiveSupport::JSON.decode @response.body
	end

  def log_in(type)
    @request.env["devise.mapping"] = Devise.mappings[type]
    user = users(type)
    sign_in user
    @ability = Ability.new(user)
  end

  def log_out(type)
    @request.env["devise.mapping"] = Devise.mappings[type]
    sign_out users(type)
  end

end
