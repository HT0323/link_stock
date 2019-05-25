Rails.application.routes.draw do

  resources :posts
  root 'static_pages#top'
  devise_for :users

end
