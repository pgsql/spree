require 'test_helper'

class PrintControllerTest < ActionController::TestCase
  test "should get orders" do
    get :orders
    assert_response :success
  end

end
