require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase

	include Devise::TestHelpers
	include Warden::Test::Helpers

	setup do
		@public = feeds(:public)
		@private = feeds(:private)
		@mib1 = torrents('1MiB')
		@mib10 = torrents('10MiB')
	end

	test 'should get public feed permissions as unauthenticated' do
		validate_can_read_permissions(@public)
	end

	test 'should get public feed permissions as subscriber' do
		validate_can_read_permissions(@public, :subscriber)
	end

	test 'should get public feed permissions as publisher' do
		validate_can_read_permissions(@public, :publisher)
	end

	test 'should get public feed permissions as admin' do
		validate_can_read_permissions(@public, :admin)
	end

	test 'should not get private feed permissions as unauthenticated' do
		validate_cannot_read_permissions(@private)
	end

	test 'should get private feed permissions as subscriber' do
		validate_can_read_permissions(@private, :subscriber)
	end

	test 'should get private feed permissions as publisher' do
		validate_can_read_permissions(@private, :publisher)
	end

	test 'should get private feed permissions as admin' do
		validate_can_read_permissions(@private, :admin)
	end

	def validate_can_read_permissions(feed, user = nil)
		log_in user if(user)
		get :index, feed_id: feed.id, format: :json
		assert_response :success
		assert_equal 2, json_response.length		
	end

	def validate_cannot_read_permissions(feed, user = nil)
		log_in user if(user)
		get :index, feed_id: feed.id, format: :json
		assert_response :redirect
	end

end
