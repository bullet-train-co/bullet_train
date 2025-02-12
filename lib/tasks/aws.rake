namespace :aws do
  desc "Set default CORS permissions on your S3 bucket"
  task set_cors: :environment do
    begin
      require "aws-sdk-s3"
    rescue LoadError
      require "colorize"
      puts "We were unable to require the `aws-sdk-s3` gem.".yellow
      puts "If you want to use S3 you should uncomment the line in the `Gemfile` for `aws-sdk-s3`.".yellow
      abort "Aborting this task because we were unable to require `aws-sdk-s3`.".red
    end

    # Fetch the settings defined in `config/storage.yml`.
    Rails.application.eager_load!
    s3_config = Rails.configuration.active_storage.service_configurations.with_indifferent_access[:amazon]

    # Create an S3 client
    s3_client = Aws::S3::Client.new(
      region: s3_config[:region],
      access_key_id: s3_config[:access_key_id],
      secret_access_key: s3_config[:secret_access_key]
    )

    # Define the CORS configuration
    cors_configuration = {
      cors_rules: [
        {
          allowed_headers: ["*"],
          allowed_methods: ["GET", "PUT", "POST", "DELETE", "HEAD"],
          # Only allow this application's base URL as an origin.
          # If this isn't permissive enough, you can change this to ["*"].
          allowed_origins: [ENV["BASE_URL"]],
          expose_headers: ["ETag"],
          max_age_seconds: 3000
        }
      ]
    }

    # Set the CORS configuration on the bucket
    s3_client.put_bucket_cors(
      bucket: s3_config[:bucket],
      cors_configuration: cors_configuration
    )

    puts "CORS configuration set successfully for bucket '#{s3_config[:bucket]}'"
  end
end
