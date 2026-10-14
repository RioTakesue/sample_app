class UsersController < ApplicationController

  #beforeフィルターにlogged_in_userを追加
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

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

      reset_session
      log_in @user #ユーザー登録中にログイン

      #ユーザー登録ページにフラッシュメッセージを追加
      flash[:success] = "Welcome to the Sample App!"

      #リダイレクト
      redirect_to @user 

    else
      render 'new', status: :unprocessable_entity      
    end
  end

  #ユーザーのeditアクション
  def edit
  end

  def update
    if @user.update(user_params) #更新に成功した場合を扱う
      flash[:success] = "Profile updated"
      redirect_to @user
      
    else
      render 'edit', status: :unprocessable_entity
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end


  private #外部から見えないように

    # create actionでStrong Parametersを使う
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                   :password_confirmation)
    end

    # before filter
    
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    #管理者かどうか確認
    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end
end
