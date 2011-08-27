Cal::Application.routes.draw do
  resources :events
  resources :businesses, :except=>[:index]
  resources :business_users, :except=>[:index,:show] do
    collection do
      get :login
      post :login_submit
    end
  end
  root :to => 'users#login'
end
