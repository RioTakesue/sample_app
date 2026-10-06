#Sessionsコントローラのcreateアクション
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session #ログイン直前に必ずこれを書く
      log_in user

      #ユーザーログイン後にユーザー情報のページにリダイレクト
      redirect_to user
    else
      #エラーメッセージを作成
      flash.now[:danger] = 'Invalid email/password combination' #flash.nowでリクエスト発生時メッセージ消滅
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
