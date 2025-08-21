# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for development. Use convenience scripts in bin/docker-dev to use it.
# Build image:
# ./bin/docker-dev/build
# Create container:
# ./bin/docker-dev/create
# Start container:
# ./bin/docker-dev/start
# You can get a shell to see what's on the build image by doing:
# ./bin/docker-dev/shell
# Or you can run a rails console
# ./bin/docker-dev/console

# Sometimes it's handy to build the image with long output and skip the cache:
# docker build -t untitled_application_dev -f dev.Dockerfile --build-arg BULLET_TRAIN_VERSION=$(grep -m 1 BULLET_TRAIN_VERSION Gemfile | cut -d '"' -f 2) . --no-cache --progress=plain

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html



#######################################################################################################
# bullet_train/dev provides dependencies
ARG BULLET_TRAIN_VERSION=fake.version
ARG FROM_IMAGE=ghcr.io/bullet-train-co/bullet_train/dev:$BULLET_TRAIN_VERSION
FROM $FROM_IMAGE AS dev

# ✅ ⬇️  Install your native development dependencies below


# ✅ ⬆️  Install your native development dependencies above

# Run as the rails user that we create in the bullet_train/dev image
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-dev/entrypoint"]

# Start the dev server by default, this can be overwritten at runtime
CMD ["./bin/dev"]
