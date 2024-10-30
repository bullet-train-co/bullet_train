# This file exists to serve as an "integration target" for super scaffolding oauth providers.
# Whenever you generate an oauth provider this file will be modified to include some utility
# methods that allow the integration to work smoothly.
#
# For more info about super scaffolding oauth providers see the documentation here:
# https://bullettrain.co/docs/oauth#oauth-providers
#
# For more info about this file and what happens to it when you generate a provider
# see this GitHub issue:
# https://github.com/bullet-train-co/bullet_train/issues/941#issuecomment-2447355572

# 🚅 super scaffolding will insert new oauth providers above this line.

def any_oauth_enabled?
  [
    stripe_enabled?,
    # 🚅 super scaffolding will insert new oauth provider checks above this line.
  ].select(&:present?).any?
end

# Starting in Rails 7.2 the line in config/application.rb that requires this file
# started to throw this error:
# Minitest::UnexpectedError: NameError: uninitialized constant BulletTrainOauthScaffolderSupport
# We define an empty module here to make that error go away.
module BulletTrainOauthScaffolderSupport
end
