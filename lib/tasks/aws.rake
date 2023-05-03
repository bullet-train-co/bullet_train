require "aws-sdk-s3"

namespace :aws do
  desc "Set default CORS permissions on your S3 bucket"
  task set_cors: :environment do |_t|
    # Create an S3 client
    s3_client = Aws::S3::Client.new(
      # TODO I wouldn't mind replacing these with functions that figure out the right place to get these values.
      # This would make it easier to add support for other providers than just Bucketeer.
      # See `storage.yml` as well.
      region: ENV["AWS_S3_REGION"] || ENV["BUCKETEER_AWS_REGION"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"] || ENV["BUCKETEER_AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"] || ENV["BUCKETEER_AWS_SECRET_ACCESS_KEY"]
    )

    # Specify the bucket name.
    bucket_name = ENV["AWS_S3_BUCKET"] || ENV["BUCKETEER_BUCKET_NAME"]

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
      bucket: bucket_name,
      cors_configuration: cors_configuration
    )

    puts "CORS configuration set successfully for bucket '#{bucket_name}'"
  end
end
