class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])

    #  ① user が存在する（メールアドレスが間違っていない）
    #  ② !user.activated? が true（まだ有効化されていないユーザーである）
    #  ③ URLのトークン（params[:id]）がDBのダイジェストと一致する（正しいURLである）
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user

    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
