Nuller::Application.routes.draw do
  get "/", :to => "main_page#index", as: 'user_root'
  devise_for :user do
    get "/login", :to => "devise/sessions#new" # Add a custom sign in route for user sign in
    get "/users/sign_out", :to => "devise/sessions#destroy" # Add a custom sing out route for user sign out
    get "/register", :to => "devise/registrations#new" # Add a Custom Route for Registrations
  end
end
