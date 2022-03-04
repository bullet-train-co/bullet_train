authenticate :user, lambda { |u| u.developer? } do
  # Sidekiq provides a web-based interface.
  require "sidekiq/web"
  mount Sidekiq::Web => "/developers/sidekiq"
end
