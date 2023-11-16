Rails.application.routes.draw do
  # ログイン
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  root to: 'tasks#index'
  # 新規登録前の確認
  resources :tasks do
    post :confirm, action: :confirm_new, on: :new
    post :import, on: :collection
  end

  # ユーザー管理
  namespace :admin do
    resources :users
  end
end
