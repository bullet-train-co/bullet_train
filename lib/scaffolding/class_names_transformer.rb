class Scaffolding::ClassNamesTransformer
  attr_accessor :child, :parent, :namespace

  def initialize(child, parent, namespace = "account")
    self.child = child
    self.parent = parent
    self.namespace = namespace
  end

  def belongs_to_needs_class_definition?
    return false if parent_namespace_parts.empty?
    return false if parent_namespace_parts == namespace_parts
    namespace_parts.first(parent_namespace_parts.count) != parent_namespace_parts
  end

  def namespace_parts
    parts[0..-2]
  end

  def parent_namespace_parts
    parent_parts[0..-2]
  end

  def parts
    child.split("::")
  end

  def parent_parts
    parent.empty? ? [""] : parent.split("::")
  end

  def parent_in_namespace_class_name
    parent_parts.last
  end

  def in_namespace_class_name
    parts.last
  end

  def all_parts_in_context
    working_parts = parts
    working_parent_parts = parent_parts

    # e.g. Webhooks::Incoming::Event vs. Webhooks::Incoming::Delivery
    while working_parts.first == working_parent_parts.first
      # get rid of 'Webhooks::' and 'Incoming::'
      working_parts.shift
      working_parent_parts.shift
    end

    # e.g. Conversation vs. Conversations::Subscription
    while working_parts.first == working_parent_parts.first.pluralize
      # get rid of 'Conversations::'
      working_parts.shift
    end

    [working_parts, working_parent_parts]
  end

  def parts_in_context
    all_parts_in_context.first
  end

  def parent_parts_in_context
    all_parts_in_context.last
  end

  def class_name_in_parent_context
    parts_in_context.join("::")
  end

  def parent_class_name_in_context
    parent_parts_in_context.join("::")
  end

  def parent_variable_name_in_context
    parent_parts_in_context.join("::").underscore.tr("/", "_")
  end

  def parent_table_name
    parent.underscore.tr("/", "_").pluralize
  end

  def table_name
    child.underscore.tr("/", "_").pluralize
  end

  def replacement_for(string)
    case string

    when "Scaffolding::AbsolutelyAbstract::CreativeConcepts"
      parent.pluralize
    when "Scaffolding::CompletelyConcrete::TangibleThings"
      child.pluralize
    when "scaffolding/absolutely_abstract/creative_concepts"
      parent.underscore.pluralize
    when "scaffolding/completely_concrete/tangible_things"
      child.underscore.pluralize
    when "scaffolding/completely_concrete/_tangible_things"
      parts = child.underscore.split("/")
      parts.push "_#{parts.pop}"
      parts.join("/").pluralize
    when "scaffolding_absolutely_abstract_creative_concepts"
      parent.underscore.tr("/", "_").pluralize
    when "scaffolding_completely_concrete_tangible_things"
      child.underscore.tr("/", "_").pluralize
    when "scaffolding-absolutely-abstract-creative-concepts"
      parent.underscore.gsub(/[\/_]/, "-").pluralize
    when "scaffolding-completely-concrete-tangible-things"
      child.underscore.gsub(/[\/_]/, "-").pluralize

    when "Scaffolding::AbsolutelyAbstract::CreativeConcept"
      parent
    when "Scaffolding::CompletelyConcrete::TangibleThing"
      child
    when "scaffolding/absolutely_abstract/creative_concept"
      parent.underscore
    when "scaffolding/completely_concrete/tangible_thing"
      child.underscore
    when "scaffolding_absolutely_abstract_creative_concept"
      parent.underscore.tr("/", "_")
    when "scaffolding_completely_concrete_tangible_thing"
      child.underscore.tr("/", "_")
    when "scaffolding-absolutely-abstract-creative-concept"
      parent.underscore.gsub(/[\/_]/, "-")
    when "scaffolding-completely-concrete-tangible-thing"
      child.underscore.gsub(/[\/_]/, "-")

    when "absolutely_abstract_creative_concepts"
      parent_class_name_in_context.underscore.tr("/", "_").pluralize
    when "completely_concrete_tangible_things"
      class_name_in_parent_context.underscore.tr("/", "_").pluralize
    when "absolutely_abstract/creative_concepts"
      parent_class_name_in_context.underscore.pluralize
    when "completely_concrete/tangible_things"
      class_name_in_parent_context.underscore.pluralize
    when "absolutely-abstract-creative-concepts"
      parent.underscore.gsub(/[\/_]/, "-").pluralize
    when "completely-concrete-tangible-things"
      child.underscore.gsub(/[\/_]/, "-").pluralize

    when "absolutely_abstract_creative_concept"
      parent_class_name_in_context.underscore.tr("/", "_")
    when "completely_concrete_tangible_thing"
      class_name_in_parent_context.underscore.tr("/", "_")
    when "absolutely_abstract/creative_concept"
      parent_class_name_in_context.underscore
    when "completely_concrete/tangible_thing"
      class_name_in_parent_context.underscore
    when "absolutely-abstract-creative-concept"
      parent.underscore.gsub(/[\/_]/, "-")
    when "completely-concrete-tangible-thing"
      child.underscore.gsub(/[\/_]/, "-")

    when "creative_concepts"
      parent_in_namespace_class_name.underscore.pluralize
    when "tangible_things"
      in_namespace_class_name.underscore.pluralize
    when "Creative Concepts"
      parent_in_namespace_class_name.titlecase.pluralize
    when "Tangible Things"
      in_namespace_class_name.titlecase.pluralize
    when "creative-concepts"
      parent_in_namespace_class_name.underscore.gsub(/[\/_]/, "-").pluralize
    when "tangible-things"
      in_namespace_class_name.underscore.gsub(/[\/_]/, "-").pluralize

    when "creative_concept"
      parent_in_namespace_class_name.underscore
    when "tangible_thing"
      in_namespace_class_name.underscore
    when "Creative Concept"
      parent_in_namespace_class_name.titlecase
    when "Tangible Thing"
      in_namespace_class_name.titlecase
    when "creative-concept"
      parent_in_namespace_class_name.underscore.gsub(/[\/_]/, "-")
    when "tangible-thing"
      in_namespace_class_name.underscore.gsub(/[\/_]/, "-")

    when ":account"
      ":#{namespace}"
    when "/account/"
      "/#{namespace}/"

    else
      "🛑"
    end
  end
end
