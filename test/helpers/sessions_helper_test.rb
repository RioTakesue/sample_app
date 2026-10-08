require "test_helper"

#永続的セッションのテスト
class SessionsHelperTest < ActionView::TestCase
  
  def setup

    #fixturesからmichaelというユーザーを取得し、変数＠userに保存
    @user = users(:michael)

    #ユーザーを記録するメソッドを実行→永続クッキーにトークンなどを保存
    remember(@user)
  end

  #一時セッションがnilの時、current_userが正しいユーザーを返すかを検証するテスト
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  #記録ダイジェストが不正な場合、current_userがnilを返すかを検証するテスト
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end 