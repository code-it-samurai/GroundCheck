Rails.application.routes.draw do
  resources :user_sports_masters
  resources :ground_sports_masters
  devise_for :users, controllers: {
        registrations: 'users/registrations',
        passwords: 'users/passwords',
        sessions: 'users/sessions'
      }
  resources :reservations, only: [:new, :create, :edit, :update]
  resources :grounds, only: [:show, :update, :create, :new, :edit, :destroy]
  resources :users, only: [:show, :update, :create, :new, :edit]
  root 'pages#home'
  get 'groundprofile' => 'grounds#groundprofile'
  get 'about' => 'pages#about'
  get 'groundresults' => 'pages#groundresults'
  get 'reservation_history' => 'pages#reservation_history'
  get 'favorites_list' => 'pages#favorites_list'
  get 'my_grounds' => 'pages#my_grounds'
  post 'ground_search' => 'pages#ground_search' 
  post 'check_in_client' => 'pages#check_in_client'
  post 'add_favorites' => 'pages#add_2_favorites'
  post 'cancelreservation' => 'pages#cancelreservation'
  delete 'destroyall' => 'reservations#destroyall'
  delete 'remove_favorites' => 'pages#remove_from_favorites'
  # user profile
  # reservation history
  # profile edit
end
