Cal::Application.routes.draw do
  resources :events
  resources :business
  match "/calendar" => "events#calendar", :via=>:get
  root :to => 'events#calendar'
end
