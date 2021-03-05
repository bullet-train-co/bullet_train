redis_conn = proc {
  Redis.new(
    url: ENV["REDIS_URL"] || "redis://localhost:6379",
    driver: :ruby,
    ssl_params: {verify_mode: OpenSSL::SSL::VERIFY_NONE}
  )
}

Sidekiq.configure_client do |config|
  # TODO how does `size` here affect `concurrency` configuration from `sidekiq.yml`?
  config.redis = ConnectionPool.new(size: 5, &redis_conn)
end

Sidekiq.configure_server do |config|
  # TODO how does `size` here affect `concurrency` configuration from `sidekiq.yml`?
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end
