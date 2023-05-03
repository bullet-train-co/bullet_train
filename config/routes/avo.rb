authenticate :user, lambda { |u| u.developer? } do
  mount Avo::Engine, at: Avo.configuration.root_path
end
