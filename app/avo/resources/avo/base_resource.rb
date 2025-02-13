unless Object.const_defined?("Avo::Configuration")
  module Avo
    class BaseResource
      def self.title=(new_title)
      end

      def self.includes=(new_includes)
      end
    end
  end
end
