Rails.application.routes.draw do
  resources :user_sports_masters
  resources :ground_sports_masters
  devise_for :users, controllers: {
        registrations: 'users/registrations',
        passwords: 'users/passwords',
        sessions: 'users/sessions'
      }
  resources :sports_masters
  resources :reservations
  resources :grounds
  resources :users
  root 'pages#home'
  get 'groundprofile' => 'grounds#groundprofile'
  get 'about' => 'pages#about'
  get 'groundresults' => 'pages#groundresults'
  post 'cancelreservation' => 'pages#cancelreservation'
  get 'reservation_history' => 'pages#reservation_history'
  get 'favorites_list' => 'pages#favorites_list'
  post 'add_favorites' => 'pages#add_2_favorites'
  delete 'destroyall' => 'reservations#destroyall'
  delete 'remove_favorites' => 'pages#remove_from_favorites'
  get 'my_grounds' => 'pages#my_grounds'
  post 'ground_search' => 'pages#ground_search'
end
