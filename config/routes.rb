Rails.application.routes.draw do
  # By default engine routes are drawn after application routes, so this is our best attempt at allowing engines to
  # define routing concerns (like `sortable`) that can be used by application routes in this file.
  BulletTrain.routing_concerns.each { |concern| instance_eval &concern }

  # This is helpful to have around when working with shallow routes and complicated model namespacing. We don't use this
  # by default, but sometimes Super Scaffolding will generate routes that use this for `only` and `except` options.
  collection_actions = [:index, :new, :create]

  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    omniauth_callbacks: "account/oauth/omniauth_callbacks"
  }

  devise_scope :user do
    scope :users, as: :users do
      post "pre_otp", to: "sessions#pre_otp"
    end
  end

  scope module: "public" do
    root to: "home#index"
    get "invitation" => "home#invitation", :as => "invitation"
    if show_developer_documentation?
      get "docs", to: "home#docs"
      get "docs/*page", to: "home#docs"
    end
  end
  authenticate :user, lambda { |u| u.developer? } do
    # sidekiq provides a web-based interface.
    require "sidekiq/web"
    mount Sidekiq::Web => "/developers/sidekiq"
  end

  namespace :webhooks do
    namespace :incoming do
      resources :bullet_train_webhooks
      namespace :oauth do
        # 🚅 super scaffolding will insert new oauth provider webhooks above this line.
      end
    end
  end

  namespace :account do
    shallow do
      # TODO we need to either implement a dashboard or deprecate this.
      root to: "dashboard#index", as: "dashboard"

      resource :two_factor, only: [:create, :destroy]

      # user-level onboarding tasks.
      namespace :onboarding do
        # routes for standard onboarding steps are configured in the `bullet_train` gem, but you can add more here.
      end

      # user specific resources.
      resources :users do
        namespace :oauth do
          # 🚅 super scaffolding will insert new oauth providers above this line.
        end

        # routes for standard user actions and resources are configured in the `bullet_train` gem, but you can add more here.
      end

      # team-level resources.
      resources :teams do
        # routes for many teams actions and resources are configured in the `bullet_train` gem, but you can add more here.

        # add your resources here.

        resources :invitations do
          # routes for standard invitation actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        resources :memberships do
          # routes for standard membership actions and resources are configured in the `bullet_train` gem, but you can add more here.
        end

        namespace :integrations do
          # 🚅 super scaffolding will insert new integration installations above this line.
        end

        namespace :platform do
          resources :applications
        end

      end
    end
  end
end
