Rails.application.routes.draw do
  root to: "welcome#index"

  get "welcome/index"

  get "/machines/new", to: "machines#new_machine", as: "new_machine"

  post "/machines", to: "machines#create", as: "create_machine"

  resources :machines, only: [:create, :index]

  get '/machines/show_machine/:id', to: 'machines#show_machine', as: 'show_machine'
end
