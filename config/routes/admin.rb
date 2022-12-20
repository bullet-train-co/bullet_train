# See `config/routes.rb` for details.
collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment
extending = {only: []} # standard:disable Lint/UselessAssignment

# 🚅 Don't remove this block, it will break Super Scaffolding.
shallow do
  namespace :admin do
    resources :applications do
      resources :teams
      resources :users
    end
  end
end
