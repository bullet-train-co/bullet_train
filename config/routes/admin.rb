# See `config/routes.rb` for details.
collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment
extending = {only: []} # standard:disable Lint/UselessAssignment

# 🚅 Don't remove this block, it will break Super Scaffolding.
shallow do
  namespace :admin do
    resources :applications do
      resources :teams do
        scope module: "teams" do
          resources :masquerade_actions, only: collection_actions
        end
      end

      namespace :teams do
        resources :masquerade_actions, except: collection_actions do
          member do
            post :revoke
          end
        end
      end

      resources :users
    end
  end
end
