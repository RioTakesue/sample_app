Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root "static_pages#home"
  get "/help",    to: "static_pages#help"
  get "/about",   to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup",  to: "users#new"

  #ログイン機構でRESTfulアクションをgetできるようにする
  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  #Usersリソースをroutesファイルに追加する
  resources :users do
    member do
      get :following, :followers
    end
  end

  #アカウント有効化に使うリソース（editアクション）を追加する
  resources :account_activations, only: [:edit]

  #パスワード再設定用リソースを追加
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # マイクロポストリソースのルーティング
  resources :microposts,          only: [:create, :destroy]

  resources :relationships,       only: [:create, :destroy]

  get '/microposts', to: 'static_pages#home'
end