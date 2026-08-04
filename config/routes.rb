Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  scope "/api/v1" do
    resources :assets, only: [ :index, :show, :create, :update, :destroy ] do
      resources :paths, only: [ :index, :show, :create, :update, :destroy ]
    end

    get "assets/:id/history",
    to: "json_histories#index"

    get "assets/:id/history/:history_id",
        to: "json_histories#show"

    delete "assets/:id/history/:history_id",
        to: "json_histories#destroy"

    post "assets/:id",
        to: "assets#create_json",
        as: :asset_json_history

    get "assets/:id/:index",
        to: "assets#history",
        as: :asset_history

    get "racks/:id/assets",
      to: "racks#all_assets",
      as: :rack_assets

    resources :templates, only: [ :index, :show, :create, :update, :destroy ] do
      resources :template_paths,
      path: "paths",
      only: [ :index, :show, :create, :update, :destroy ]
    end

    resources :users, only: [ :create, :destroy ]

    post "users/login",
      to: "users#login",
      as: :user_login

    resources :racks, only: [ :index, :show, :create, :update, :destroy ]
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
