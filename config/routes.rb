Cal::Application.routes.draw do
  resources :events, :except=>[:index]
  resources :businesses, :except=>[:index] do
    collection do
      get :events
    end
  end
  resources :consumers, :only=>[:index] do
    collection do
      get :search_location
      get :events
    end
  end
  resources :users, :only=>[:index,:show] do
     collection do
       get :set_favorite
       get :unset_favorite
     end
  end
  resources :business_users, :except=>[:index,:show] do
    collection do
      get :login
      post :login_submit
    end
  end
  root :to => 'users#login'
end
