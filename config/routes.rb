Rails.application.routes.draw do
  root to: "users#index"
  resources :users, only:[:index]
  post "result", to: "users#result" 
  get "result", to: "users#result" 
end
