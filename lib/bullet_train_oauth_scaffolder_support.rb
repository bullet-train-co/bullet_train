# TODO This file is going away, but we need it temporarily for compatibility with the integration scaffolder.

# 🚅 super scaffolding will insert new oauth providers above this line.

def any_oauth_enabled?
  [
    stripe_enabled?,
    # 🚅 super scaffolding will insert new oauth provider checks above this line.
  ].select(&:present?).any?
end
