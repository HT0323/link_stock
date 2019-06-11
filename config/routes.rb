Rails.application.routes.draw do

  resources :posts, except: [:show]
  post 'posts/search', to: 'posts#search'
  root 'posts#index'
  devise_for :users
end
