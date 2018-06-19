Rails.application.routes.draw do
  root to: 'pages#home'
  get '/home', to: 'pages#home'

  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  devise_scope :user do
    get 'signup', to: 'devise/registrations#new'
  end

  resources :deliverers, only: %i[index new create edit update]
  resources :shifts, only: %i[index new create edit update]

  resources :assignments, only: %i[index new create]

  get '/api/available_shifts', to: 'shifts#available_shifts'
end
