Rails.application.routes.draw do

  devise_for :admin_users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }


  Plezi.route '/ws', ChatServer


  devise_scope :user do
    post 'signup/send_sms' => 'users/registrations#send_sms'
  end

  get '/valid/:attr' => 'validations#valid'

  post '/chatroom/request_addr' => 'chatroom#request_addr'

  get 'basketball' => 'home#basketball', as: :basketball
  get 'baseball' => 'home#baseball', as: :baseball
  get 'soccer' => 'home#soccer', as: :soccer

  namespace :admin do
    resources :users
    
    root to: 'home#index'
  end

  root to: 'home#index'
end
