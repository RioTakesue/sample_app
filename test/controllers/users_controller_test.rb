require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  #Tests the redirect of the index action
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  # Tests ensuring unauthorized users cannot access edit/update actions  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: {
      user: {
        name:  @user.name,
        email: @user.email
      }
    }

    assert_not flash.empty?
    assert_redirected_to login_url
  end

  #一般ユーザーがパラメータを改ざんして不正に管理者権限を取得するのを防ぐテスト
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: {
        password:              "password",
        password_confirmation: "password",
        admin: true
      }
    }
    assert_not @other_user.reload.admin?
  end

  #Testing edit and update when logged in as the wrong user 
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: {
      user: {
        name:  @user.name,
        email: @user.email
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end

  #管理者権限の制御をアクションレベルでテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
