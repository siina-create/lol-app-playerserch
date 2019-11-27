Rails.application.routes.draw do
  root to: "users#index"
  resources :users
  get "result", to:  "users#result" 
end
