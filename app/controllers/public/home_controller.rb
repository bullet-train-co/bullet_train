class Public::HomeController < Public::ApplicationController
  # Uncomment `include RootRedirect` and comment out `def index ... end` to
  # redirect `/` to either `ENV["MARKETING_SITE_URL"]` or the sign-in page.
  # include RootRedirect

  # Allow your application to disable public sign-ups and be invitation only.
  include InviteOnlySupport

  # Make Bullet Train's documentation available at `/docs`.
  include DocumentationSupport

  def index
  end
end
