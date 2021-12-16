# TODO Why doesn't this autoload?
require_relative "../../app/serializers/api/v1/application_serializer"

GrapeSwagger.model_parsers.register(GrapeSwagger::Jsonapi::Parser, Api::V1::ApplicationSerializer)
