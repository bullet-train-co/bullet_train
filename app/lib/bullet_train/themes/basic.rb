module BulletTrain
  module Themes
    module Basic
      class Theme < BulletTrain::Themes::Light::Theme
        def directory_order
          ["basic"] + super
        end
      end
    end
  end
end
