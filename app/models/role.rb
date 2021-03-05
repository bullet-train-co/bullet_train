class Role < ApplicationRecord
  # 🚫 DEFAULT BULLET TRAIN MEMBERSHIP FUNCTIONALITY
  # Typically you should avoid adding your own functionality in this section to avoid merge conflicts in the future.
  # (If you specifically want to change Bullet Train's default behavior, that's OK and you can do that here.)

  # ✅ YOUR APPLICATION'S MEMBERSHIP FUNCTIONALITY
  # This is the place where you should implement your own features on top of Bullet Train's functionality. There
  # are a bunch of Super Scaffolding hooks here by default to try and help keep generated code logically organized.

  MANAGEABLE_ROLE_KEYS_BY_ROLE = {

    admin: [
      :admin,
    ],

    another_role_key: [],

    # this isn't an actual role in the database, it represents the roles that can be assigned by any user.
    all: [

      # we include this role both as an example of how roles can be created and assigned, but also for the sake
      # of the automated test suite. we recommend you leave this here, and set the `HIDE_EXAMPLES` environment
      # variable to true, except for your test environment, so the integration tests will still run.
      (:another_role_key unless sample_role_disabled?),

    ].compact,

  }

  # 🚅 add concerns above.

  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add oauth providers above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  # 🚅 add methods above.

  # 🚫 DEFAULT BULLET TRAIN MEMBERSHIP FUNCTIONALITY
  # We put these at the bottom of this file to keep them out of the way. You should define your own methods above here.

  def self.administrative_role_keys
    [:admin]
  end

  def self.admin
    find_or_create_by(key: :admin)
  end

  def self.roles_managable_by_all
    Role.where(key: MANAGEABLE_ROLE_KEYS_BY_ROLE[:all])
  end

  def admin?
    key == :admin
  end

  def key
    super.to_sym
  end

  def manageable_roles
    Role.where(key: MANAGEABLE_ROLE_KEYS_BY_ROLE[key])
  end
end
