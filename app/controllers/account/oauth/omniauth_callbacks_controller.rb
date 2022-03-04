class Account::Oauth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Account::Oauth::OmniauthCallbacks::ControllerBase

  # TODO Allow packages like `bullet_train-integrations-stripe` to register these automatically.
  def stripe_connect
    callback("Stripe", team_id_from_env)
  end

  # 🚅 super scaffolding will insert new oauth providers above this line.
end
