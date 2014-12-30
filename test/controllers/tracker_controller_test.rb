require 'test_helper'

class TrackerControllerTest < ActionController::TestCase

	include Devise::TestHelpers
	include Warden::Test::Helpers

	setup do
		@public = feeds(:public)
		@private = feeds(:private)
	end

	PEER_ID_PACKED = "-UM1860-A\x8E.\xEE\xA9\r\u000F{\xAFĲ#"

	# ANNOUNCE

	test 'should announce only public torrents as unauthenticated' do
		validate_can_announce_as(@public)
		validate_cannot_announce_as(@private)
	end

	test 'should announce only public torrents as unassigned' do
		validate_can_announce_as(@public, :unassigned)
		validate_cannot_announce_as(@private, :unassigned)
	end

	test 'should announce public and private torrents as subscriber' do
		validate_can_announce_as(@public, :subscriber)
		validate_can_announce_as(@private, :subscriber)
	end

	test 'should announce public and private torrents as publisher' do
		validate_can_announce_as(@public, :publisher)
		validate_can_announce_as(@private, :publisher)
	end

	test 'should announce public and private torrents as admin' do
		validate_can_announce_as(@public, :admin)
		validate_can_announce_as(@private, :admin)
	end

	def validate_can_announce_as(feed, user = nil)
		log_in user if(user)
		# puts "AT: #{users(user).authentication_token}" if user
		get :announce, info_hash: [feed.torrents[0].info_hash].pack('H*'), peer_id: PEER_ID_PACKED
		assert_response :success
	end

	def validate_cannot_announce_as(feed, user = nil)
		log_in user if(user)
		# puts "AT: #{users(user).authentication_token}" if user
		get :announce, info_hash: [feed.torrents[0].info_hash].pack('H*'), peer_id: PEER_ID_PACKED
		assert_response :redirect
	end

	# SCRAPE

	test 'should scrape only public torrents as unauthenticated' do
		validate_scrape_count(1)
	end

	test 'should scrape only public torrents as unassigned' do
		validate_scrape_count(1, :unassigned)
	end

	test 'should scrape all authorized torrents as subscriber' do
		validate_scrape_count(2, :subscriber)
	end

	test 'should scrape all authorized torrents as publisher' do
		validate_scrape_count(2, :publisher)
	end

	test 'should scrape all torrents as admin' do
		validate_scrape_count(2, :admin)
	end

	def validate_scrape_count(count, user = nil)
		log_in user if(user)
		get :scrape
		# puts response
		assert_equal 'text/html; charset=utf-8', response.headers['Content-Type']
		data = BEncode.load(response.body)
		files = data['files']
		assert_not_nil files
		assert_equal count, files.length
	end

end
