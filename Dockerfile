# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t untitled_application .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name untitled_application untitled_application

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

#######################################################################################################
FROM docker.io/bullet_train/base AS base

# ✅ ⬇️  Install your native runtime dependencies below


# ✅ ⬆️  Install your native runtime dependencies above

#######################################################################################################
# Throw-away build stage to reduce size of final image
FROM docker.io/bullet_train/build AS build

# bullet_train/build provides pre-built verisons of all the gems in the starter repo. We copy them to our
# new image to save time.
RUN ls -al "${BUNDLE_PATH}/ruby/3.4.0/gems"
# TODO: Does this really get us anything. Should BUNDLE_PATH already be in place?
# The output from the ls -al command above is showing all the gems I would expect,
# so I'm pretty sure there's not need to explictly copy the BUNDLE_PATH
# COPY --from=docker.io/bullet_train/build "${BUNDLE_PATH}" "${BUNDLE_PATH}"

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
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




#######################################################################################################
# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]
