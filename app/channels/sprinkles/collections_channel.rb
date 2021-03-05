class Sprinkles::CollectionsChannel < ApplicationCable::Channel
  def subscribed
    @parent = validated_parent_class.accessible_by(current_ability, :show).find(params[:parent_id]) || connection.reject_unauthorized_connection
    current_ability.authorize! :show, @parent
    # TODO this is a weird situation with `has_many through:` since the built object has no reference to the parent.
    # in that case, we need a special permission in the ability file.
    current_ability.authorize! :index, @parent.send(validated_collection_name).build
    stream_from "#{@parent.class.name.underscore}_#{@parent.id}_#{validated_collection_name}"
  end

  def allowed_collections
    {
      User => [],
      Team => [
        :scaffolding_things,
      ],
    }
  end

  def allowed_parent_classes
    allowed_collections.keys
  end

  def validated_parent_class
    allowed_parent_classes.select { |klass| klass.name == params[:parent_name] }.first ||
      connection.reject_unauthorized_connection
  end

  def validated_collection_name
    collection_name = params[:collection_name].to_sym
    connection.reject_unauthorized_connection unless allowed_collections[validated_parent_class].include?(collection_name)
    collection_name
  end
end
