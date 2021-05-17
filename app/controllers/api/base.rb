require "grape-swagger"

class Api::Base < Grape::API
  content_type :jsonapi, "application/vnd.api+json"
  formatter :json, Grape::Formatter::Jsonapi
  formatter :jsonapi, Grape::Formatter::Jsonapi
  format :jsonapi
  default_error_formatter :json

  # TODO Shouldn't this be in V1 or not versioned?
  include Api::V1::ExceptionsHandler

  mount Api::V1::Root

  # Swagger docs are available at `/api/swagger_doc.json`.
  add_swagger_documentation \
    hide_documentation_path: true,
    api_version: "v1",
    info: {
      title: I18n.t("application.name"),
      description: I18n.t("application.description")
    },
    endpoint_auth_wrapper: WineBouncer::OAuth2
end
