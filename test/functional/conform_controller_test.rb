require 'test_helper'

class ConformControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
