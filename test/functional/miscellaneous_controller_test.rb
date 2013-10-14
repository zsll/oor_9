require 'test_helper'

class MiscellaneousControllerTest < ActionController::TestCase
  test "should get sign_in" do
    get :sign_in
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

end
