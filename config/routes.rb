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
      post :set_favorite
      post :unset_favorite
      post :event_vote
      post :oauth_create
      post :facebook_register
      post :register_college
    end
  end

  resources :authentications, only: [:create]
  match '/auth/:provider/callback', to: 'authentications#create'

  resources :business_users, except: [:index, :show] do
    collection do
      get :login
      post :login_submit
    end
  end
  root to: 'consumers#home'
end
