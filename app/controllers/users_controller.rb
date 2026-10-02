class UsersController < ApplicationController

  #Usersコントローラーのshowアクション
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new #newアクションに@user変数を追加
  end

  #ユーザー登録の失敗に対応できるcreateアクション
  def create
    @user = User.new(user_params)
    if @user.save #保存の成功をここで扱う

      #ユーザー登録ページにフラッシュメッセージを追加
      flash[:success] = "Welcome to the Sample App!"

      #リダイレクト
      redirect_to @user 

    else
      render 'new', status: :unprocessable_entity      
    end
  end

  private #外部から見えないように

    #create actionでStrong Parametersを使う
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
