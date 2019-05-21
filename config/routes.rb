Rails.application.routes.draw do

  root 'static_pages#top'
  devise_for :users

end
