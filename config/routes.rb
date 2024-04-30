Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "articles#index"

  get "/articles", to: "articles#index"
  get 'weather_controller/index'

  namespace :api do
    namespace :v1 do
      resources :file_uploads, only: [:create]
    end
  end  
end
