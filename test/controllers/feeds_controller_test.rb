require 'test_helper'

class FeedsControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  include Warden::Test::Helpers


  VALID = { name: :bad, description: :bad, slug: :bad, enable_public_archiving: true, replication_percentage: 20 }

  setup do
    @public = feeds(:public)
    @private = feeds(:private)
  end

  # INDEX

  test "should get index without as unauthenticated" do
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns[:feeds]
    assert_equal 1, json_response.length
    assert_equal feeds(:public)[:name], json_response[0]['name']
  end

  test "should get index without as unassigned" do
    log_in :unassigned
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns[:feeds]
    assert_equal 1, json_response.length
    assert_equal feeds(:public)[:name], json_response[0]['name']
  end

  test "should get index without as subscriber" do
    log_in :subscriber
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns[:feeds]
    assert_equal 2, json_response.length
    assert_equal feeds(:private)[:name], json_response[0]['name']
    assert_equal feeds(:public)[:name], json_response[1]['name']
  end

  test "should get index without as publisher" do
    log_in :publisher
    get :index, format: :json
    assert_response :success
    assert_not_nil assigns[:feeds]
    assert_equal 2, json_response.length
    assert_equal feeds(:private)[:name], json_response[0]['name']
    assert_equal feeds(:public)[:name], json_response[1]['name']
  end

  # CREATE

  test "should not create feed unauthenticated" do
    assert_no_difference('Feed.count') do
      post :create, feed: VALID, format: :json
      assert_response :unauthorized 
    end

  end

  test "should create feed as admin" do
    log_in :admin
    assert_difference('Feed.count', 1) do
      post :create, feed: VALID, format: :json
      assert_response :success
    end
  end

  # READ

  test "should show public feeds as unauthenticated" do
    get :show, id: @public, format: :json
    assert_response :success
  end

  test "should show public feeds as unassigned" do
    log_in :unassigned
    get :show, id: @public, format: :json
    assert_response :success
  end

  test "should show public feeds as subscriber" do
    log_in :subscriber
    get :show, id: @public, format: :json
    assert_response :success
  end

  test "should show public feeds as publisher" do
    log_in :publisher
    get :show, id: @public, format: :json
    assert_response :success
  end

  test "should show public feeds as admin" do
    log_in :admin
    get :show, id: @public, format: :json
    assert_response :success
  end

  test "should not show private feeds as unauthenticated" do
    get :show, id: @private, format: :json
    assert_response :redirect
  end

  test "should not show private feeds as unassigned" do
    log_in :unassigned
    get :show, id: @private, format: :json
    assert_response :redirect
  end

  test "should show private feeds as subscriber" do
    log_in :subscriber
    get :show, id: @private, format: :json
    assert assigns(:feed)
    assert_response :success
  end

  test "should show private feeds as publisher" do
    log_in :publisher
    get :show, id: @private, format: :json
    assert assigns(:feed)
    assert_response :success
  end

  test "should show private feeds as admin" do
    log_in :admin
    get :show, id: @private, format: :json
    assert assigns(:feed)
    assert_response :success
  end

  # UPDATE

  test "should not update feed as unauthenticated" do
    patch :update, id: @public, feed: VALID, format: :json
    assert_response :unauthorized
  end

  test "should not update feed as unassigned" do
    log_in :unassigned
    patch :update, id: @public, feed: VALID, format: :json
    assert_response :redirect
  end

  test "should not update feed as subscriber" do
    log_in :subscriber
    patch :update, id: @public, feed: VALID, format: :json
    assert_response :redirect
  end

  test "should update feed as publisher" do
    log_in :publisher
    patch :update, id: @public, feed: VALID, format: :json
    assert_response :success
  end

  test "should update feed as admin" do
    log_in :admin
    patch :update, id: @public, feed: VALID, format: :json
    assert_response :success
  end

  # DELETE

  test "should not destroy feed as unauthenticated" do
    assert_no_difference('Feed.count') do
      delete :destroy, id: @public, format: :json
    end
    assert_response :unauthorized
  end

  test "should not destroy feed as unassigned" do
    log_in :unassigned
    assert_no_difference('Feed.count') do
      delete :destroy, id: @public, format: :json
    end
    assert_response :redirect
  end

  test "should not destroy feed as subscriber" do
    log_in :subscriber
    assert_no_difference('Feed.count') do
      delete :destroy, id: @public, format: :json
    end
    assert_response :redirect
  end

  test "should destroy feed as publisher" do
    log_in :publisher
    assert_difference('Feed.count', -1) do
      delete :destroy, id: @public, format: :json
    end
    assert_response :success
  end

  test "should destroy feed as admin" do
    log_in :admin
    assert_difference('Feed.count', -1) do
      delete :destroy, id: @public, format: :json
    end
    assert_response :success
  end

end
