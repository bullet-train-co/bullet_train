# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.4.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Dependencies base image to speed things up!
FROM base as dependencies

# Install packages needed for deployment.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js (Version 20.x) and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y yarn && \
    apt-get install -y ffmpeg

RUN rm -rf /var/lib/apt/lists/* && \
    apt-get update -qq

# Throw-away build stage to reduce size of final image
FROM dependencies as prebuild

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev pkg-config libicu-dev curl

FROM prebuild as build

RUN apt-get update -qq

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle lock --add-platform aarch64-linux
RUN bundle install --no-cache
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
RUN bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Enable Corepack and install the correct version of Yarn
RUN corepack enable && corepack prepare yarn@4.2.2 --activate

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

RUN rm -rf /usr/local/bundle/ruby/3.4.0 && \
    bundle install --no-cache

# Final stage for app image
FROM dependencies

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install -y passwd && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    mkdir -p /rails/storage && \
    mkdir -p /rails/tmp/pids && \
    chown -R rails:rails db log storage config/credentials/* tmp tmp/pids # This step will fail if you haven't done `EDITOR="code --wait" bin/rails credentials:edit --environment production` before.

# Ensure the docker-entrypoint script is executable.
RUN chmod +x ./bin/docker-entrypoint

USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000

CMD ["sh", "-c", "./bin/rails server"]
