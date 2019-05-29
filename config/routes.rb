Rails.application.routes.draw do

  resources :posts, except: [:show]
  root 'posts#index'
  devise_for :users
end
