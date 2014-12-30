require 'test_helper'

class PermissionsControllerTest < ActionController::TestCase

	include Devise::TestHelpers
	include Warden::Test::Helpers

	setup do
		@public = feeds(:public)
		@private = feeds(:private)
		@mib1 = torrents('1MiB')
		@mib10 = torrents('10MiB')

		@permission = permissions(:subscriber_public)
		@good = {
			feed_id: @private.id,
			user_id: users(:unassigned).id,
			role: Permission::PUBLISHER_ROLE}
	end


	test 'should not get public feed permissions as unauthenticated' do
		validate_cannot_list_permissions(@public)
	end

	test 'should get public feed permissions as subscriber' do
		validate_can_list_permissions(@public, :subscriber)
	end

	test 'should get public feed permissions as publisher' do
		validate_can_list_permissions(@public, :publisher)
	end

	test 'should get public feed permissions as admin' do
		validate_can_list_permissions(@public, :admin)
	end

	test 'should not get private feed permissions as unauthenticated' do
		validate_cannot_list_permissions(@private)
	end

	test 'should get private feed permissions as subscriber' do
		validate_can_list_permissions(@private, :subscriber)
	end

	test 'should get private feed permissions as publisher' do
		validate_can_list_permissions(@private, :publisher)
	end

	test 'should get private feed permissions as admin' do
		validate_can_list_permissions(@private, :admin)
	end

	def validate_can_list_permissions(feed, user = nil)
		log_in user if(user)
		get :index, feed_id: feed.id, format: :json
		assert_response :success
		assert_equal 2, json_response.length		
	end

	def validate_cannot_list_permissions(feed, user = nil)
		log_in user if(user)
		get :index, feed_id: feed.id, format: :json
		assert_response :redirect
	end

	# CREATE

	test 'should not create permission as unassigned' do
		validate_cannot_create_permission :unassigned
	end

	test 'should not create permission as subscriber' do
		validate_cannot_create_permission :subscriber
	end

	test 'should create permission as publisher' do
		validate_can_create_permission :publisher
	end

	test 'should create permission as admin' do
		validate_can_create_permission :admin
	end

	def validate_can_create_permission(user = nil)
		log_in user if(user)
		assert_difference('Permission.count', 1) do	
			post :create, feed_id: @private.id, permission: @good, format: :json
		end
		assert_response :success
		assert assigns(:permission)	
	end

	def validate_cannot_create_permission(user = nil)
		log_in user if(user)
		assert_no_difference('Permission.count') do	
			post :create, feed_id: @private.id, permission: @good, format: :json
		end
		assert_response :redirect
	end


	# UPDATE

	test 'should not allow updates' do
		begin
			patch :update, id: @permission, format: :json
			flunk 'controller should not support UPDATE'
		rescue
		end
	end

	# DELETE

	test 'should not delete private feed permissions as unassigned' do
		validate_cannot_delete_permission(@permission, :unassigned)
	end

	test 'should not delete private feed permissions as subscriber' do
		validate_cannot_delete_permission(@permission, :subscriber)
	end

	test 'should delete private feed permissions as publisher' do
		validate_can_delete_permission(@permission, :publisher)
	end

	test 'should delete private feed permissions as admin' do
		validate_can_delete_permission(@permission, :admin)
	end

	def validate_can_delete_permission(p, user = nil)
		log_in user if(user)
		assert_difference('Permission.count', -1) do
			delete :destroy, id: p, feed_id: p.feed.id, format: :json
		end
		assert_response :success
	end

	def validate_cannot_delete_permission(p, user = nil)
		log_in user if(user)
		assert_no_difference('Permission.count') do
			delete :destroy, id: p, feed_id: p.feed.id, format: :json
		end
		assert_response :redirect
	end

end
