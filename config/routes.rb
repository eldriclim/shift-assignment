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

  get '/assignments/show', to: 'assignments#show'

  get '/assignments/new', to: 'assignments#new'

  post '/assignments/search', to: 'assignments#search'

  post '/assignments/create', to: 'assignments#create'

  post '/assignments/show', to: 'assignments#show'
end
