Rails.application.routes.draw do
  root to: "machines#index"

  get "welcome/index"

  get "/machines/new", to: "machines#new_machine", as: "new_machine"

  post "/decode", to: "decode#execute"



  put "/machines/:id", to: "machines#update", as: "update_machine"

  resources :machines, only: [:create, :index, :update, :destroy]

  resources :machines do
    member do
      get "run", to: "run#show"
      post "run", to: "run#execute"
    end
  end

  get "/machines/show_machine/:id", to: "machines#show_machine", as: "show_machine"

  devise_for :users, controllers: { registrations: "users/registrations" }


end
