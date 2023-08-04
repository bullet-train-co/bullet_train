if openai_enabled?
  OpenAI.configure do |config|
    config.access_token = ENV["OPENAI_ACCESS_TOKEN"]
    config.organization_id = ENV["OPENAI_ORGANIZATION_ID"] if openai_organization_exists?

    # Set request timeout. Default is 120 seconds.
    # config.request_timeout = 25
  end
end
