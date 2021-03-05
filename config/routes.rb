Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # TODO 🍩 figure out how to extract this for the sprinkles gem.
  # e.g. `resources :things, concerns: [:sortable]`
  concern :sortable do
    collection do
      post :reorder
    end
  end

  collection_actions = [:index, :new, :create]

  devise_for :users, controllers: {
    registrations: "registrations",
    omniauth_callbacks: "account/oauth/omniauth_callbacks"
  }

  scope module: "public" do
    root to: "home#index"
    get "invitation" => "home#invitation", :as => "invitation"
    if show_developer_documentation?
      get "docs", to: "home#docs"
      get "docs/*page", to: "home#docs"
    end
  end
  authenticate :user, lambda { |u| u.developer? } do
    # # RAILS ADMIN
    # # ⚠️ this is commented out because it represents a major liability for you and a major risk for your customers data
    # # unless you have a robust security policy enforced around your admin user accounts. i don't know if we'll ever
    # # enable this by default, but i certainly wouldn't enable it in any application that didn't require two-factor
    # # authentication for developer accounts.
    # mount RailsAdmin::Engine => '/developers/admin', as: 'rails_admin'

    # sidekiq provides a web-based interface.
    require "sidekiq/web"
    mount Sidekiq::Web => "/developers/sidekiq"
  end

  namespace :webhooks do
    namespace :incoming do
      resources :bullet_train_webhooks
      resources :stripe_webhooks
      namespace :oauth do
        resources :stripe_account_webhooks
      end
    end
  end

  namespace :account do
    shallow do
      # TODO we need to either implement a dashboard or deprecate this.
      root to: "dashboard#index", as: "dashboard"

      # this is the route the cloudinary field hits.
      namespace :cloudinary do
        resources :upload_signatures
      end

      # user-level onboarding tasks.
      namespace :onboarding do
        resources :user_details
        resources :user_email
      end

      # user specific resources.
      resources :users do
        resources :api_keys
      end

      # team-level resources.
      resources :teams do
        namespace :imports do
          namespace :csv do
            unless scaffolding_things_disabled?
            end
          end
        end

        namespace :oauth do
          resources :stripe_accounts if stripe_enabled?
          # 🚅 super scaffolding will insert new oauth providers above this line.
        end

        namespace :webhooks do
          namespace :outgoing do
            resources :events
            resources :endpoints do
              resources :deliveries, only: [:index, :show] do
                resources :delivery_attempts, only: [:index, :show]
              end
            end
          end
        end

        # add your resources here.
        unless scaffolding_things_disabled?
          namespace :scaffolding do
            namespace :absolutely_abstract do
              resources :creative_concepts do
                scope module: "creative_concepts" do
                  resources :collaborators, only: collection_actions
                end

                namespace :creative_concepts do
                  resources :collaborators, except: collection_actions
                end
              end
            end
            resources :absolutely_abstract_creative_concepts, path: "absolutely_abstract/creative_concepts" do
              namespace :completely_concrete do
                resources :tangible_things
              end
            end
          end
        end

        resources :invitations do
          member do
            get :accept
            post :accept
          end
        end

        resources :memberships do
          member do
            post :demote
            post :promote
            post :reinvite
          end

          scope module: "memberships" do
            namespace :reassignments do
              resources :scaffolding_completely_concrete_tangible_things_reassignments, only: [:new, :create, :index]
            end
          end

          namespace :memberships do
            namespace :scaffolding do
              namespace :completely_concrete do
                resources :tangible_things
              end
            end

            namespace :reassignments do
              resources :scaffolding_completely_concrete_tangible_things_reassignments, only: [:show]
            end
          end
        end

        member do
          post :switch_to
        end
      end
    end
  end

  if demo?
    get "/call", to: redirect("https://calendly.com/bullettrain/introductions"), as: "call"
  end
end
