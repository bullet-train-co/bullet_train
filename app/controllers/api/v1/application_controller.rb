require "pagy_cursor/pagy/extras/cursor"
require "pagy_cursor/pagy/extras/uuid_cursor"

class Api::V1::ApplicationController < ActionController::API
  include ActionController::Helpers
  helper ApplicationHelper

  include LoadsAndAuthorizesResource
  include Pagy::Backend

  def self.regex_to_remove_controller_namespace
    /^Api::V1::/
  end

  before_action :doorkeeper_authorize!

  def permitted_fields
    []
  end

  def permitted_arrays
    {}
  end

  def process_params(strong_params)
  end
  
  # TODO Why doesn't `before_action :doorkeeper_authorize!` throw an exception?
  class NotAuthenticatedError < StandardError
  end

  def current_user
    raise NotAuthenticatedError unless doorkeeper_token.present?
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  before_action :apply_pagination, only: [:index]

  def apply_pagination
    collection_variable = "@#{self.class.name.split("::").last.gsub("Controller", "").underscore}"
    collection = instance_variable_get collection_variable
    @pagy, collection = pagy_cursor collection
    instance_variable_set collection_variable, collection
  end

  before_action :set_default_response_format

  def set_default_response_format
    request.format = :json
  end

  rescue_from CanCan::AccessDenied, ActiveRecord::RecordNotFound do |exception| 
    render json: {error: 'Not found'}, status: :not_found
  end

  rescue_from NotAuthenticatedError do |exception| 
    render json: {error: 'Invalid token'}, status: :unauthorized
  end
end