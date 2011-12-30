LocalEyes::Application.routes.draw do
  resources :events, except: [:index]
  resources :businesses, except: [:index] do
    collection do
      get :events
      get :geocode
    end
  end

  resources :consumers, only: [:index] do
    collection do
      get :search_location
      get :search_college
      get :home
      get :index
      get :events
      post :notify
    end
  end
  get :event_list, to: 'consumers#event_list', as: :event_list_consumers

  resources :users, only: [:index, :new, :create] do
    collection do
      get :set_favorite
      get :unset_favorite
      post :oauth_create
      post :facebook_register
      post :register_college
    end
  end
  match '/auth/:provider/callback', to: 'users#create'

  resources :business_users, except: [:index, :show] do
    collection do
      get :login
      post :login_submit
    end
  end
  root to: 'consumers#home'
end
