# See `config/routes.rb` for details.
collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment
extending = {only: []}

shallow do
  namespace :v1 do
    # user specific resources.
    resources :users, extending do
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth providers above this line.
      end

      # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
    end

    # team-level resources.
    resources :teams, extending do
      # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

      # add your resources here.

      resources :invitations, extending do
        # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      resources :memberships, extending do
        # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      namespace :integrations do
        # 🚅 super scaffolding will insert new integration installations above this line.
      end
    end
  end
end
