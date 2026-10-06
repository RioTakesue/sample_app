require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do

    #Sessionコントローラのテストで名前付きルーティングを使うようにする
    #元々：　get sessions_new_url
    get login_path
    assert_response :success
  end
end
