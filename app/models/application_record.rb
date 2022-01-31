class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Bullet Train includes a lot of functionality in each model by default.
  # If you want to avoid this for specific models, consider inheriting from `ActiveRecord::Base` directly.
  include Records::Base
end
