# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for development.
# Build:
# docker build -t untitled_application_dev -f dev.Dockerfile --build-arg BULLET_TRAIN_VERSION=$(grep -m 1 BULLET_TRAIN_VERSION Gemfile | cut -d '"' -f 2) .
# Run:
# docker run -dt -p 3000:3000 --mount type=bind,src="$(pwd)",dst=/rails -e DATABASE_USERNAME="$(whoami)" --name untitled_application_dev untitled_application_dev

# Sometimes it's handy to get long output and skip the cache:
# docker build -t untitled_application_dev -f dev.Dockerfile --build-arg BULLET_TRAIN_VERSION=$(grep -m 1 BULLET_TRAIN_VERSION Gemfile | cut -d '"' -f 2) . --no-cache --progress=plain
#
# You can then get a console to see what's on the build image by doing:
# docker run --mount type=bind,src="$(pwd)",dst=/rails -e DATABASE_USERNAME="$(whoami)" -it untitled_application_dev /bin/bash

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

#######################################################################################################
# bullet_train/dev provides dependencies
# TODO: How can we get this version number in a better way?
ARG BULLET_TRAIN_VERSION=fake.version
ARG FROM_IMAGE=ghcr.io/bullet-train-co/bullet_train/dev:$BULLET_TRAIN_VERSION
FROM $FROM_IMAGE AS dev

# ✅ ⬇️  Install your native development dependencies below


# ✅ ⬆️  Install your native development dependencies above

# Run as the rails user that we create in the bullet_train/dev image
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-dev/entrypoint"]
#EXPOSE 80
EXPOSE 3000

CMD ["./bin/dev"]
