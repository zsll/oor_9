require 'test_helper'

class FbControllerTest < ActionController::TestCase
  test "should get users" do
    get :users
    assert_response :success
  end

  test "should get albums" do
    get :albums
    assert_response :success
  end

  test "should get photos" do
    get :photos
    assert_response :success
  end

end
