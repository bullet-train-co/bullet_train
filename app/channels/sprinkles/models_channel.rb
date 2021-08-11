class Sprinkles::ModelsChannel < ApplicationCable::Channel
  def subscribed
    @model = validated_model_class.accessible_by(current_ability, :show).find(params[:model_id]) || connection.reject_unauthorized_connection
    current_ability.authorize! :show, @model
    stream_from "#{@model.class.name.underscore}_#{@model.id}"
  end

  def allowed_model_classes
    @allowed_model_classes ||= [
      Team,
      Scaffolding::AbsolutelyAbstract::CreativeConcept,
    ]
  end

  def validated_model_class
    allowed_model_classes.find { |klass| klass.name == params[:model_name] } ||
      connection.reject_unauthorized_connection
  end
end
