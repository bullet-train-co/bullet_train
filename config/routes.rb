Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  namespace :api do
  end

  namespace :app do
    resource :teams do
    end
  end

  namespace :docs do
  end

end
