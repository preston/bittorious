require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

	include Devise::TestHelpers
	include Warden::Test::Helpers


	test 'should get static pages' do
		validate_static_page(:concepts)
		validate_static_page(:history)
		validate_static_page(:landing)
		validate_static_page(:deployment)
		validate_static_page(:legal)
		validate_static_page(:getting_started)
		validate_static_page(:faq)
	end

	def validate_static_page(page)
		get page
		assert_response :success
		log_in :unassigned
		get page
		assert_response :success
	end

	test 'should get dashboard only when authorized' do
		get :dashboard
		assert_response :redirect
		log_in :unapproved
		get :dashboard
		assert_response :redirect

		log_in :subscriber
		get :dashboard
		assert_response :success
	end

	test 'should get dashboard templates only when authorized' do
		get :torrents
		assert_response :redirect
		get :settings
		assert_response :redirect
		get :feeds
		assert_response :redirect

		log_in :subscriber

		get :torrents
		assert_response :success
		assert_select 'h4', 'Data RSS Feed'
		get :settings
		assert_response :success
		get :feeds
		assert_response :success
		assert_select 'h2', 'Data Feeds'
	end

	test 'should not get status non-admin' do
		get :status
		assert_response :redirect
		log_in :publisher
		get :status
		assert_response :redirect
	end

	test 'should get status as admin' do
		log_in :admin
		get :status
		assert_response :success
	end

	test 'should allow visiting landing when unauthenticated' do
		get :landing
		assert_response :success		
	end

	test 'should allow visiting landing when authenticated' do
		log_in :subscriber
		get :landing
		assert_response :success		
	end

end