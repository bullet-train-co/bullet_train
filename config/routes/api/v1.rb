# See `config/routes.rb` for details.
collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment
extending = {only: []}

shallow do
  namespace :v1 do
    # user specific resources.
    model "User", extending do
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth providers above this line.
      end

      # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
    end

    # team-level resources.
    model "Team", extending do
      # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

      # add your resources here.

      model "Invitation", extending do
        # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      model "Membership", extending do
        # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      namespace :integrations do
        # 🚅 super scaffolding will insert new integration installations above this line.
      end
    end
  end
end
