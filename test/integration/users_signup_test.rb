require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  #無効なユーザー登録に対するテスト
  test "invalid signup information" do

    #ユーザー登録ページにアクセス
    get signup_path

    #POSTリクエストをusers_pathに送信
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name:  "",
          email: "user@invalid",
          password:              "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'

    #エラーメッセージをテストする
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  #有効なユーザー登録に対するテスト
  test "valid signup information" do

    #ブロック内の処理完了後、ユーザー数が１増えることを検証
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Example User",
          email: "user@example.com",
          password:              "password",
          password_confirmation: "password"
        } 
      }
    end
    follow_redirect!
    assert_template 'users/show'

    #flashが空でないことをテスト
    assert_not flash.empty?
  end
end
