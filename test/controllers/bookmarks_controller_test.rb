require 'test_helper'

class BookmarksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should redirect to index" do
    post :new
    assert_response :redirect
  end

end
