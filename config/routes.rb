Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  resources :assets, only: [ :index, :show, :create, :destroy ]

  patch "/assets/:id",
        to: "assets#update"

  post "assets/:id",
       to: "assets#create_json",
       as: :asset_json_history

  get "assets/:id/:index",
      to: "assets#history",
      as: :asset_history

  resources :racks

  # Defines the root path route ("/")
  # root "posts#index"
end
