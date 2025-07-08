# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# Build:
# docker build -t untitled_application --build-arg BULLET_TRAIN_VERSION=$(grep -m 1 BULLET_TRAIN_VERSION Gemfile | cut -d '"' -f 2) .
# Run:
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name untitled_application untitled_application

# Sometimes it's handy to get long output and skip the cache:
# docker build -t untitled_application --build-arg BULLET_TRAIN_VERSION=$(grep -m 1 BULLET_TRAIN_VERSION Gemfile | cut -d '"' -f 2) . --no-cache --progress=plain
#
# You can then get a console to see what's on the build image by doing:
# docker run -it untitled_application /bin/bash

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

#######################################################################################################
# Throw-away build stage to reduce size of final image
# bullet_train/build provides build-time dependencies and pre-built verisons of all the gems in the starter repo.
# TODO: How can we get this version number in a better way?
ARG BULLET_TRAIN_VERSION=FAKE.VERSION
ARG FROM_IMAGE=ghcr.io/bullet-train-co/bullet_train/build:$BULLET_TRAIN_VERSION
FROM $FROM_IMAGE AS build

# ✅ ⬇️  Install your native build-time dependencies below


# ✅ ⬆️  Install your native build-time dependencies above

# Install application gems
COPY Gemfile Gemfile.lock .ruby-version package.json yarn.lock ./
RUN bundle install --clean && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    echo "about to bootsnap precompile----------------------------" && \
    bundle exec bootsnap precompile --gemfile && \
    echo "about to yarn install-----------------------------------" && \
    yarn install

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
ENTRYPOINT ["/rails/bin/docker/entrypoint"]

# Start server by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/rails", "server"]
