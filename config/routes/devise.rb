devise_for :users, controllers: {
  registrations: "registrations",
  sessions: "sessions",
  omniauth_callbacks: "account/oauth/omniauth_callbacks"
}

devise_scope :user do
  scope :users, as: :users do
    post "pre_otp", to: "sessions#pre_otp"
  end
end
