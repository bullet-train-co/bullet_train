def default_url_options_from_base_url
  unless ENV["BASE_URL"].present?
    if Rails.env.development?
      ENV["BASE_URL"] ||= "http://localhost:3000"
    else
      raise "you need to define the value of ENV['BASE_URL'] in your environment. if you're on heroku, you can do this with `heroku config:add BASE_URL=https://your-app-name.herokuapp.com` (or whatever your configured domain is)."
    end
  end

  parsed_base_url = URI.parse(ENV["BASE_URL"])
  default_url_options = [:user, :password, :host, :port].map { |key| [key, parsed_base_url.send(key)] }.to_h

  # the name of this property doesn't match up.
  default_url_options[:protocol] = parsed_base_url.scheme

  default_url_options.compact
end

def inbound_email_enabled?
  ENV["INBOUND_EMAIL_DOMAIN"].present?
end

def subscriptions_enabled?
  false
end

def free_trial?
  ENV["STRIPE_FREE_TRIAL_LENGTH"].present?
end

def stripe_enabled?
  ENV["STRIPE_CLIENT_ID"].present?
end

# 🚅 super scaffolding will insert new oauth providers above this line.

def webhooks_enabled?
  true
end

def scaffolding_things_disabled?
  ENV["HIDE_THINGS"].present? || ENV["HIDE_EXAMPLES"].present?
end

def sample_role_disabled?
  ENV["HIDE_EXAMPLES"].present?
end

def demo?
  ENV["DEMO"].present?
end

def cloudinary_enabled?
  ENV["CLOUDINARY_URL"].present?
end

def two_factor_authentication_enabled?
  ENV["TWO_FACTOR_ENCRYPTION_KEY"].present?
end

def any_oauth_enabled?
  [
    stripe_enabled?,
    # 🚅 super scaffolding will insert new oauth provider checks above this line.
  ].select(&:present?).any?
end

def invitation_only?
  ENV["INVITATION_KEYS"].present?
end

def invitation_keys
  ENV["INVITATION_KEYS"].split(",").map(&:strip)
end

def show_developer_documentation?
  Rails.env.production? ? ENV["ENABLE_DOCS"].present? : true
end

def font_awesome?
  ENV["FONTAWESOME_NPM_AUTH_TOKEN"].present?
end

def storybook_auto_source
  file = caller.find { |s| s.include?("storybook/") }.split(":").first
  File.read(file).split("content_for :source").first.split("content_for :story").last.lines[1...-3].join.strip
end

def multiple_locales?
  @multiple_locales ||= I18n.available_locales.many?
end
