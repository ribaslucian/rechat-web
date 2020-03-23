Rails.application.routes.draw do
#  root to: 'chats#show'
  mount ActionCable.server => '/cable'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  
  namespace :guest do
    get '/', to: 'users#login'
    get '/guest', to: 'users#login'

    match 'users/sign_in', to: 'users#sign_in', via: [:get, :post], as: :sign_in
    match 'users/login', to: 'users#login', via: [:get, :post]
  end
  
  
  namespace :researcher do
    get '/', to: 'dashboard#index'
    get '/researcher', to: 'users#login'
    get 'dashboard/index', to: 'dashboard#index'
    
    get 'users/logout', to: 'users#logout', as: :logout
  end
  
end

