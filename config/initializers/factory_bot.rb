# frozen_string_literal: true

if Rails.env.test? && defined?(FactoryBot)
  class ActiveSupport::TestCase
    include FactoryBot::Syntax::Methods
  end
end
