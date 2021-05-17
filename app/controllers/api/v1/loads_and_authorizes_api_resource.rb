module Api::V1::LoadsAndAuthorizesApiResource
  extend ActiveSupport::Concern

  included do
    helpers do
      def load_and_authorize_api_resource(api_resource_class)
        raise unless api_resource_class.present?

        instance_variable_name = "@#{api_resource_class.name.demodulize.underscore}"
        instance_variable_collection_name = instance_variable_name.pluralize

        options = route.settings[:api_resource_options] || {permission: :read, skip_authorize: false}

        permission = options[:permission]
        skip_authorize = options[:skip_authorize]

        api_resource_params = declared(params, include_missing: false)
        api_resource_param_id = api_resource_params[:id]
        api_resource_params_other_ids = api_resource_params.select { |param, value|
          /_id$/i.match?(param)
        }

        all_accessible_api_resources = api_resource_class.accessible_by(current_ability, permission)

        if api_resource_param_id.present? # :read, :update, :delete
          instance_variable_set(instance_variable_name, all_accessible_api_resources.find(api_resource_param_id))
        elsif permission.eql? :create
          instance_variable_set(instance_variable_name, api_resource_class.new(api_resource_params))
        elsif permission.eql? :read
          all_accessible_api_resources = all_accessible_api_resources.where(api_resource_params_other_ids) if api_resource_params_other_ids.present?
          instance_variable_set(instance_variable_collection_name, all_accessible_api_resources)
          skip_authorize = true # can't use CanCan to authorize collections
        end

        eval "authorize! :#{permission}, #{instance_variable_name}" unless skip_authorize
      rescue ActiveRecord::RecordNotFound
        # the default RecordNotFound message includes the raw SQL... which feels bad
        handle_api_error(ActiveRecord::RecordNotFound.new("The id #{api_resource_param_id} could not be found."))
      end
    end
  end
end
