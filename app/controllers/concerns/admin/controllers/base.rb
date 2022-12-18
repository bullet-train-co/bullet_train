module Admin
end

module Admin::Controllers
end

module Admin::Controllers::Base
  extend ActiveSupport::Concern

  included do
    include LoadsAndAuthorizesResource
    include Fields::ControllerSupport

    layout "account"

    before_action :authenticate_user!
  end

  class_methods do
    # this is a template method called by LoadsAndAuthorizesResource.
    # it allows that module to understand what namespaces of a controller
    # are organizing the controllers, and which are organizing the models.
    def regex_to_remove_controller_namespace
      /^Admin::/
    end
  end
end
