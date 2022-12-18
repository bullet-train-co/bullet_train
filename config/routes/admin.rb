# See `config/routes.rb` for details.
collection_actions = [:index, :new, :create] # standard:disable Lint/UselessAssignment
extending = {only: []} # standard:disable Lint/UselessAssignment

shallow do
  resources :applications
end
