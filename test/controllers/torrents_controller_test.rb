require 'test_helper'

class TorrentsControllerTest < ActionController::TestCase

	include Devise::Test::ControllerHelpers
	include Warden::Test::Helpers

	setup do
		@public = feeds(:public)
		@private = feeds(:private)
		@mib1 = torrents('1MiB')
		@mib10 = torrents('10MiB')
		@good = {
			name: 'Good',
			user: users(:admin),
			feed: @public,
			file: fixture_file_upload('1MiB.torrent', 'application/x-bittorrent')
		}
	end

	test 'should load valid test torrents' do
		assert @mib1.valid?
		assert_not_nil @mib1.user
		assert_not_nil @mib1.feed
	end


	# INDEX

	test 'should list public torrents as unauthenticated' do
		get :index, params: { feed_id: @public }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end

	test 'should list public torrents as unassigned' do
		log_in :unassigned
		get :index, params: { feed_id: @public }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end

	test 'should list public torrents as subscriber' do
		log_in :subscriber
		get :index, params: { feed_id: @public }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end

	test 'should list public torrents as publisher' do
		log_in :publisher
		get :index, params: { feed_id: @public }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end

	test 'should list public torrents as admin' do
		log_in :admin
		get :index, params: { feed_id: @public }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end

	test 'should not list private torrents as unauthenticated' do
		get :index, params: { feed_id: @private }, format: :json
		# assert assigns(:torrents)
		assert_response :redirect
		# assert 0, json_response.length
	end


	test 'should not list private torrents as unassigned' do
		log_in :unassigned
		get :index, params: { feed_id: @private }, format: :json
		# assert assigns(:torrents)
		assert_response :redirect
	end


	test 'should list private torrents as subscriber' do
		log_in :subscriber
		get :index, params: { feed_id: @private }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end


	test 'should list private torrents as publisher' do
		log_in :publisher
		get :index, params: { feed_id: @private }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end


	test 'should list private torrents as admin' do
		log_in :admin
		get :index, params: { feed_id: @private }, format: :json
		# assert assigns(:torrents)
		assert_response :success
		assert 1, json_response.length
	end


	# CREATE

	test 'should not create torrent as unassigned' do
		validate_cannot_create :unassigned
	end

	test 'should not create torrent as subscriber' do
		validate_cannot_create :subscriber
	end

	test 'should create torrent as publisher' do
		validate_can_create :publisher
	end

	test 'should create torrent as admin' do
		validate_can_create :admin
	end

	def validate_can_create(user)
		log_in user
		assert_difference('Torrent.count', 1) do
			post :create, format: :json, params: { torrent: @good, feed_id: @public }
		end
		assert_response :success
	end

	def validate_cannot_create(user)
		log_in user
		assert_no_difference('Torrent.count') do
			post :create, format: :json, params: { torrent: @good, feed_id: @public }
		end
		assert_response :redirect
	end

	# READ

	test 'should not read private torrents as unauthenticated' do
		validate_can_read @mib1
		validate_cannot_read @mib10
	end

	test 'should not read private torrents as unassigned' do
		validate_can_read @mib1, :unassigned
		validate_cannot_read @mib10, :unassigned
	end

	test 'should read all torrents as subscriber' do
		validate_can_read @mib1, :subscriber
		validate_can_read @mib10, :subscriber
	end

	test 'should read all torrents as publisher' do
		validate_can_read @mib1, :publisher
		validate_can_read @mib10, :publisher
	end

	test 'should read all torrents as admin' do
		validate_can_read @mib1, :admin
		validate_can_read @mib10, :admin
	end

	def validate_can_read(torrent, user = nil)
		log_in user if(user)
		get :show, params: { id: torrent, feed_id: torrent.feed.id }, format: :json
		get :show, params: { id: torrent, feed_id: torrent.feed.id }, format: :torrent
		assert_response :success
	end

	def validate_cannot_read(torrent, user = nil)
		log_in user if(user)
		get :show, params: { id: torrent, feed_id: torrent.feed.id }, format: :json
		get :show, params: { id: torrent, feed_id: torrent.feed.id }, format: :torrent
		assert_response :redirect
	end

	# UPDATE

	test 'should not update torrent as unassigned' do
		validate_cannot_update :unassigned
	end

	test 'should not update torrent as subscriber' do
		validate_cannot_update :subscriber
	end

	test 'should update torrent as publisher' do
		validate_can_update :publisher
	end

	test 'should update torrent as admin' do
		validate_can_update :admin
	end

	def validate_can_update(user)
		log_in user
		patch :update, params: { id: @mib1, torrent: {name: 'New Name'}, feed_id: @public }, format: :json
		assert_response :success
	end

	def validate_cannot_update(user)
		log_in user
		patch :update, params: { id: @mib1, torrent: {name: 'New Name'}, feed_id: @public }, format: :json
		assert_response :redirect
	end

	# DELETE

	test 'should not delete torrent as unassigned' do
		validate_cannot_delete :unassigned
	end


	test 'should not delete torrent as subscriber' do
		validate_cannot_delete :subscriber
	end

	test 'should delete torrent as publisher' do
		validate_can_delete :publisher
	end

	test 'should delete torrent as admin' do
		validate_can_delete :admin
	end

	def validate_can_delete(user)
		log_in user
	    assert @ability.can?(:delete, @mib1)
    	assert_difference('Torrent.count', -1) do
			delete :destroy, params: { id: @mib1, feed_id: @public }, format: :json
		end
		assert_response :success
	end


	def validate_cannot_delete(user)
		log_in user
	    assert @ability.cannot?(:delete, @mib1)
    	assert_no_difference('Torrent.count') do
			delete :destroy, params: { id: @mib1, feed_id: @public }, format: :json
		end
		assert_response :redirect
	end

end
