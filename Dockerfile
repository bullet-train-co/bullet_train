# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t untitled_application .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name untitled_application untitled_application

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html
# TODO: Update this with info about the devcontainer that (will) ship with BT

###################################################################################################################################
# bullet_train/base provides the runtime dependencies required by Bullet Train.
FROM bullet_train/base AS base

# ✅ ⬇️  Install your native runtime dependencies below


# ✅ ⬆️  Install your native runtime dependencies above




###################################################################################################################################
# Throw-away build stage to reduce size of final image
FROM bullet_train/build:1.22.0 AS build

# bullet_train/build provides pre-built verisons of all the gems in the starter repo. We copy them to our
# new image to save time.
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"

# ✅ ⬇️  Install your native build-time dependencies below


# ✅ ⬆️  Install your native build-time dependencies above

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




###################################################################################################################################
# The final shippable image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Entrypoint prepares the database.
# TODO: Add the entrypoint script.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
# TODO: What should the CMD be?
CMD ["./bin/thrust", "./bin/rails", "server"]
