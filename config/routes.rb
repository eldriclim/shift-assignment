Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to: 'pages#home'

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  resources :deliverers, only: %i[new create edit update]
  resources :shifts, only: %i[new create edit update]

  get '/home', to: 'pages#home'

  post '/assignments', to: 'assignments#create'

  post '/assignments/show', to: 'assignments#show'

  get '/test', to: 'pages#test'
end
