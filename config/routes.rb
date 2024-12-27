Rails.application.routes.draw do
  root to: "machines#index"

  get "welcome/index"

  get "/machines/new", to: "machines#new_machine", as: "new_machine"


  put "/machines/:id", to: "machines#update", as: "update_machine"

  resources :machines, only: [:create, :index, :destroy]

  get "/machines/show_machine/:id", to: "machines#show_machine", as: "show_machine"

  devise_for :users, controllers: { registrations: "users/registrations" }


  get "/machines/:id/edit", to: "machines#edit_machine", as: "edit_machine"

end
