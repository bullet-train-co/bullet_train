# TODO This file is going away, but we need it temporarily for compatibility with the integration scaffolder.

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
# We really need to get around to fixing whatever problem makes it necessary to have this file in the first place.
# We define `any_oauth_enabled?` in the main `bullet_train` gem. Why is that not sufficient?
# https://github.com/bullet-train-co/bullet_train-core/blob/00fdeb275888c88c9a396714c5a7acebbef2e56f/bullet_train/lib/bullet_train.rb#L135-L141
module BulletTrainOauthScaffolderSupport
end
