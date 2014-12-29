require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  include Warden::Test::Helpers


  GOOD = { name: :good }

  setup do
    @unapproved = users(:unapproved) 
    @unassigned = users(:unassigned)
    @subscriber = users(:subscriber)
    @publisher = users(:publisher)
    @admin = users(:admin)
  end


  def user_show_check(type)
  	log_in type
  	get :show, id: @unapproved, format: :json
  	assert_response :redirect
  	get :show, id: @unassigned, format: :json
  	assert_response :redirect
  	get :show, id: @subscriber, format: :json
  	assert_response :redirect
  	get :show, id: @publisher, format: :json
  	assert_response :redirect
  	get :show, id: @admin, format: :json
  	assert_response :redirect
  end

  test "should not allow account self-approval" do
    log_in :unapproved
    post :approve, id: @unapproved, user: {approved: true}, format: :json
    assert_response :unauthorized
  end

  test "should not allow account approvals as unassigned" do
  	log_in :unassigned
  	post :approve, id: @unapproved, format: :json
  	assert_response :redirect
  end

  test "should not allow account approvals as subscriber" do
  	log_in :subscriber
  	post :approve, id: @unapproved, format: :json
  	assert_response :redirect
  end

  test "should not allow account approvals as publisher" do
  	log_in :publisher
  	post :approve, id: @unapproved, format: :json
  	assert_response :redirect
  end

  test "should allow admin account approvals" do
  	log_in :admin
  	post :approve, id: @unapproved, format: :json
  	assert_response :success
  end

  test "should not allow non-admin account denials" do
  	post :deny, id: @unapproved, format: :json
  	assert_response :unauthorized

  	log_in :unassigned
  	post :deny, id: @unapproved, format: :json
  	assert_response :redirect

  	log_in :subscriber
  	post :deny, id: @unapproved, format: :json
  	assert_response :redirect

  	log_in :publisher
  	post :deny, id: @unapproved, format: :json
  	assert_response :redirect
  end

  test "should allow admin account denials" do
  	log_in :admin
  	post :deny, id: @unapproved, format: :json
  	assert_response :success
  end

  test 'should show user as admin' do
  	log_in :admin
  	get :show, id: @unapproved, format: :json
  	assert_response :success
  	get :show, id: @unassigned, format: :json
  	assert_response :success
  	get :show, id: @subscriber, format: :json
  	assert_response :success
  	get :show, id: @publisher, format: :json
  	assert_response :success
  	get :show, id: @admin, format: :json
  	assert_response :success
  end


  test 'should not show user as unassigned' do
  	user_show_check :unassigned
  end

  test 'should not show user as subscriber' do
  	user_show_check :subscriber
  end

  test 'should not show user as publisher' do
  	user_show_check :publisher
  end

  test 'should not render user index as unauthenticated' do
    get :index
    assert_response :redirect
  end

  test 'should not render user index as unassigned' do
    log_in :unassigned
    get :index
    assert_response :redirect
  end


  test 'should not render user index as subscriber' do
    log_in :subscriber
    get :index
    assert_response :redirect
  end


  test 'should not render user index as publisher' do
    log_in :publisher
    get :index
    assert_response :redirect
  end

  test 'should render index as admin' do
    log_in :admin
    get :index
    assert_response :success
  end

  test 'should not update different user as publisher' do
    log_in :publisher
    patch :update, id: @subscriber, user: GOOD, format: :json
    assert_response :redirect
    assert assigns(:user)
  end

  test 'should update different user as admin' do
    log_in :admin
    patch :update, id: @subscriber, user: GOOD, format: :json
    assert_response :success
    assert assigns(:user)
  end

end
