ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # 指定のワーカー数でテストを並列実行する
  parallelize(workers: :number_of_processors)

  # test/fixtures/*.yml にあるすべてのfixture をセットアップする
  fixtures :all

  #テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
  # list 5.34 テスト環境でもApplicationヘルパーを使えるようにする
  include ApplicationHelper

  #テストユーザーとしてログイン
  def log_in_as(user)
    session[:user_id] = user.id
  end

  # （すべてのテストで使うその他のヘルパーメソッドは省略）
end

class ActionDispatch::IntegrationTest
  
  #テストユーザーとしてログイン
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end