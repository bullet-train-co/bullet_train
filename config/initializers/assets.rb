# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# These prevent `propshaft` from adding a bunch of extra, unused assets to publis/assets during precompilation.
Rails.application.config.assets.excluded_paths = [
  # TODO: Once `avo` has slimmed down what they ship maybe we can remove one or all of the Avo paths
  Avo::Engine.root.join("app/assets/builds"),
  Avo::Engine.root.join("app/assets/config"),
  Avo::Engine.root.join("app/assets/stylesheets"),
  Avo::Engine.root.join("app/assets/svgs"),
  Cloudinary::Engine.root.join("vendor/assets/html"),
  Cloudinary::Engine.root.join("vendor/assets/javascripts"),
  Doorkeeper::Engine.root.join("vendor/assets/stylesheets"),
  BulletTrain::Themes::Light::Engine.root.join("app/assets/config"),
  BulletTrain::Themes::Light::Engine.root.join("app/assets/stylesheets"),
]

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
