# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t untitled_application .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name untitled_application untitled_application

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

#######################################################################################################
# Throw-away build stage to reduce size of final image
# bullet_train/build provides build-time dependencies and pre-built verisons of all the gems in the starter repo.
# TODO: How can we get this version number in a better way?
ARG BULLET_TRAIN_VERSION=1.23.0
FROM ghcr.io/bullet-train-co/bullet_train/build:$BULLET_TRAIN_VERSION AS build

# ✅ ⬇️  Install your native build-time dependencies below


# ✅ ⬆️  Install your native build-time dependencies above

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 SPROCKETS_NO_EXPORT_CONCURRENT=1 ./bin/rails assets:precompile --trace




#######################################################################################################
# Final stage for app image
# bullet_train/base provides run-time dependencies for everything used by the framework and starter repo.
FROM ghcr.io/bullet-train-co/bullet_train/base:$BULLET_TRAIN_VERSION AS base

# ✅ ⬇️  Install your native runtime dependencies below


# ✅ ⬆️  Install your native runtime dependencies above

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Make sure that all the directories we expect are actually there
# TODO: Maybe we should do this in the base image in the core repo?
RUN mkdir -p db log storage tmp

# Run and own only the runtime files as a non-root user for security
RUN chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
