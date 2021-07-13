# TODO `options` is overriden in tons of places.
require "indefinite_article"

class Scaffolding::Transformer
  attr_accessor :child, :parent, :parents, :class_names_transformer, :options, :additional_steps

  def initialize(child, parents, options = {})
    self.child = child
    self.parent = parents.first
    self.parents = parents
    self.class_names_transformer = Scaffolding::ClassNamesTransformer.new(child, parent)
    self.options = options
    self.additional_steps = []
  end

  RUBY_NEW_FIELDS_PROCESSING_HOOK = "# 🚅 super scaffolding will insert processing for new fields above this line."
  RUBY_NEW_ARRAYS_HOOK = "# 🚅 super scaffolding will insert new arrays above this line."
  RUBY_NEW_FIELDS_HOOK = "# 🚅 super scaffolding will insert new fields above this line."
  RUBY_ADDITIONAL_NEW_FIELDS_HOOK = "# 🚅 super scaffolding will also insert new fields above this line."
  RUBY_EVEN_MORE_NEW_FIELDS_HOOK = "# 🚅 super scaffolding will additionally insert new fields above this line."
  ENDPOINTS_HOOK = "# 🚅 super scaffolding will mount new endpoints above this line."
  ERB_NEW_FIELDS_HOOK = "<%#{RUBY_NEW_FIELDS_HOOK} %>"
  CONCERNS_HOOK = "# 🚅 add concerns above."
  BELONGS_TO_HOOK = "# 🚅 add belongs_to associations above."
  HAS_MANY_HOOK = "# 🚅 add has_many associations above."
  OAUTH_PROVIDERS_HOOK = "# 🚅 add oauth providers above."
  HAS_ONE_HOOK = "# 🚅 add has_one associations above."
  SCOPES_HOOK = "# 🚅 add scopes above."
  VALIDATIONS_HOOK = "# 🚅 add validations above."
  CALLBACKS_HOOK = "# 🚅 add callbacks above."
  DELEGATIONS_HOOK = "# 🚅 add delegations above."
  METHODS_HOOK = "# 🚅 add methods above."

  def encode_double_replacement_fix(string)
    string.chars.join("~!@BT@!~")
  end

  def decode_double_replacement_fix(string)
    string.gsub("~!@BT@!~", "")
  end

  def transform_string(string)
    [

      # full class name plural.
      "Scaffolding::AbsolutelyAbstract::CreativeConcepts",
      "Scaffolding::CompletelyConcrete::TangibleThings",
      "scaffolding/absolutely_abstract/creative_concepts",
      "scaffolding/completely_concrete/tangible_things",
      "scaffolding/completely_concrete/_tangible_things",
      "scaffolding_absolutely_abstract_creative_concepts",
      "scaffolding_completely_concrete_tangible_things",
      "scaffolding-absolutely-abstract-creative-concepts",
      "scaffolding-completely-concrete-tangible-things",

      # full class name singular.
      "Scaffolding::AbsolutelyAbstract::CreativeConcept",
      "Scaffolding::CompletelyConcrete::TangibleThing",
      "scaffolding/absolutely_abstract/creative_concept",
      "scaffolding/completely_concrete/tangible_thing",
      "scaffolding_absolutely_abstract_creative_concept",
      "scaffolding_completely_concrete_tangible_thing",
      "scaffolding-absolutely-abstract-creative-concept",
      "scaffolding-completely-concrete-tangible-thing",

      # class name in context plural.
      "absolutely_abstract_creative_concepts",
      "completely_concrete_tangible_things",
      "absolutely_abstract/creative_concepts",
      "completely_concrete/tangible_things",
      "absolutely-abstract-creative-concepts",
      "completely-concrete-tangible-things",

      # class name in context singular.
      "absolutely_abstract_creative_concept",
      "completely_concrete_tangible_thing",
      "absolutely_abstract/creative_concept",
      "completely_concrete/tangible_thing",
      "absolutely-abstract-creative-concept",
      "completely-concrete-tangible-thing",

      # just class name singular.
      "creative_concepts",
      "tangible_things",
      "creative-concepts",
      "tangible-things",
      "Creative Concepts",
      "Tangible Things",

      # just class name plural.
      "creative_concept",
      "tangible_thing",
      "creative-concept",
      "tangible-thing",
      "Creative Concept",
      "Tangible Thing"

    ].each do |needle|
      string = string.gsub(needle, encode_double_replacement_fix(class_names_transformer.replacement_for(needle)))
    end
    decode_double_replacement_fix(string)
  end

  def get_transformed_file_content(file)
    transformed_file_content = []

    skipping = false
    gathering_lines_to_repeat = false

    parents_to_repeat_for = []
    gathered_lines_for_repeating = nil

    File.open(file).each_line do |line|
      if line.include?("# 🚅 skip when scaffolding.")
        next
      end

      if line.include?("# 🚅 skip this section if resource is nested directly under team.")
        skipping = true if parent == "Team"
        next
      end

      if line.include?("# 🚅 skip this section when scaffolding.")
        skipping = true
        next
      end

      if line.include?("# 🚅 stop any skipping we're doing now.")
        skipping = false
        next
      end

      if line.include?("# 🚅 for each child resource from team down to the resource we're scaffolding, repeat the following:")
        gathering_lines_to_repeat = true
        parents_to_repeat_for = ([child] + parents.dup).reverse
        gathered_lines_for_repeating = []
        next
      end

      if line.include?("# 🚅 stop repeating.")
        gathering_lines_to_repeat = false

        while parents_to_repeat_for.count > 1
          current_parent = parents_to_repeat_for[0]
          current_child = parents_to_repeat_for[1]
          current_transformer = self.class.new(current_child, current_parent)
          transformed_file_content << current_transformer.transform_string(gathered_lines_for_repeating.join)
          parents_to_repeat_for.shift
        end

        next
      end

      if gathering_lines_to_repeat
        gathered_lines_for_repeating << line
        next
      end

      if skipping
        next
      end

      # remove lines with 'remove in scaffolded files.'
      unless line.include?("remove in scaffolded files.")

        # only transform it if it doesn't have the lock emoji.
        if line.include?("🔒")
          # remove any comments that start with a lock.
          line.gsub!(/\s+?#\s+🔒.*/, "")
        else
          line = transform_string(line)
        end

        transformed_file_content << line

      end
    end

    transformed_file_content.join
  end

  def scaffold_file(file)
    transformed_file_content = get_transformed_file_content(file)
    transformed_file_name = transform_string(file)

    transformed_directory_name = File.dirname(transformed_file_name)
    unless File.directory?(transformed_directory_name)
      FileUtils.mkdir_p(transformed_directory_name)
    end

    puts "Writing '#{transformed_file_name}'."

    File.open(transformed_file_name, "w+") do |f|
      f.write(transformed_file_content.strip + "\n")
    end

    if transformed_file_name.split(".").last == "rb"
      puts "Fixing Standard Ruby on '#{transformed_file_name}'."
      # `standardrb --fix #{transformed_file_name} 2> /dev/null`
    end
  end

  def scaffold_directory(directory)
    # TODO rescue whatever the actual error is here.
    begin
      Dir.mkdir(transform_string(directory))
    rescue
      nil
    end
    Dir.foreach(directory) do |file|
      file = "#{directory}/#{file}"
      unless File.directory?(file)
        scaffold_file(file)
      end
    end
  end

  def add_line_to_file(file, content, after, options = {})
    increase_indent = options[:increase_indent]
    add_before = options[:add_before]
    add_after = options[:add_after]

    transformed_file_name = file
    transformed_content = content
    transformed_after = after

    target_file_content = File.open(transformed_file_name).read

    if target_file_content.include?(transformed_content)
      puts "No need to update '#{transformed_file_name}'. It already has '#{transformed_content}'."

    else

      new_target_file_content = []

      target_file_content.split("\n").each do |line|
        # TODO i forget what the transformed after stuff is.
        if options[:exact_match] ? line == transformed_after : line.match(/#{Regexp.escape(transformed_after)}\s*$/)

          if add_before
            new_target_file_content << "#{line} #{add_before}"
          else
            unless options[:prepend]
              new_target_file_content << line
            end
          end

          # TODO i forget what the transformed after stuff is.
          line =~ /^(\s*).*#{Regexp.escape(transformed_after)}.*/
          leading_whitespace = $1

          incoming_leading_whitespace = nil
          transformed_content.lines.each do |content_line|
            content_line.rstrip
            content_line =~ /^(\s*).*/
            # this ignores empty lines.
            # it accepts any amount of whitespace if we haven't seen any whitespace yet.
            if content_line.present? && $1 && (incoming_leading_whitespace.nil? || $1.length < incoming_leading_whitespace.length)
              incoming_leading_whitespace = $1
            end
          end

          incoming_leading_whitespace ||= ""

          transformed_content.lines.each do |content_line|
            new_target_file_content << "#{leading_whitespace}#{"  " if increase_indent}#{content_line.gsub(/^#{incoming_leading_whitespace}/, "").rstrip}".presence
          end

          new_target_file_content << "#{leading_whitespace}#{add_after}" if add_after

          if options[:prepend]
            new_target_file_content << line
          end

        else

          new_target_file_content << line

        end
      end

      puts "Updating '#{transformed_file_name}'."

      File.open(transformed_file_name, "w+") do |f|
        f.write(new_target_file_content.join("\n").strip + "\n")
      end

    end
  end

  def scaffold_add_line_to_file(file, content, after, options = {})
    file = transform_string(file)
    content = transform_string(content)
    after = transform_string(after)
    add_line_to_file(file, content, after, options)
  end

  def replace_line_in_file(file, content, in_place_of)
    target_file_content = File.open(file).read

    if target_file_content.include?(content)
      puts "No need to update '#{file}'. It already has '#{content}'."
    else
      puts "Updating '#{file}'."
      target_file_content.gsub!(in_place_of, content)
      File.open(file, "w+") do |f|
        f.write(target_file_content)
      end
    end
  end

  def scaffold_replace_line_in_file(file, content, in_place_of)
    file = transform_string(file)
    # we specifically don't transform the content, we assume a builder function created this content.
    in_place_of = transform_string(in_place_of)
    replace_line_in_file(file, content, in_place_of)
  end

  # if class_name isn't specified, we use `child`.
  # if class_name is specified, then `child` is assumed to be a parent of `class_name`.
  # returns an array with the ability line and a boolean indicating whether the ability line should be inserted among
  # the abilities for admins only. (this happens when building an ability line for a resources that doesn't ultimately
  # belong to a Team or a User.)
  def build_ability_line(class_names = nil)
    # e.g. ['Conversations::Message', 'Conversation']
    if class_names
      # e.g. 'Conversations::Message'
      class_name = class_names.shift
      # e.g. ['Conversation', 'Deliverable', 'Phase', 'Project', 'Team']
      working_parents = class_names + [child] + parents
    else
      # e.g. 'Deliverable'
      class_name = child
      # e.g. ['Phase', 'Project', 'Team']
      working_parents = parents.dup
    end

    case working_parents.last
    when "User"
      working_parents.pop
      ability_line = "user_id: user.id"
    when "Team"
      working_parents.pop
      ability_line = "team_id: user.team_ids"
    else
      # if a resources is specified that isn't ultimately owned by a team or a user, then only admins can manage it.
      return ["can :manage, #{class_name}", true]
    end

    # e.g. ['Phase', 'Project']
    while working_parents.any?
      current_parent = working_parents.pop
      current_transformer = Scaffolding::ClassNamesTransformer.new(working_parents.last || class_name, current_parent)
      ability_line = "#{current_transformer.parent_variable_name_in_context}: {#{ability_line}}"
    end

    # e.g. "can :manage, Deliverable, phase: {project: {team_id: user.team_ids}}"
    ["can :manage, #{class_name}, #{ability_line}", false]
  end

  def build_conversation_ability_line
    build_ability_line(["Conversations::Message", "Conversation"])
  end

  def build_factory_setup
    class_name = child
    working_parents = parents.dup
    current_parent = working_parents.pop
    current_transformer = Scaffolding::Transformer.new(working_parents.last || class_name, [current_parent])

    setup_lines = []

    unless current_parent == "Team" || current_parent == "User"
      setup_lines << current_transformer.transform_string("@absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept)")
    end

    previous_assignment = current_transformer.transform_string("absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept")

    current_parent = working_parents.pop

    while current_parent
      current_transformer = Scaffolding::Transformer.new(working_parents.last || class_name, [current_parent])
      setup_lines << current_transformer.transform_string("@absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, #{previous_assignment})")
      previous_assignment = current_transformer.transform_string("absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept")

      current_parent = working_parents.pop
    end

    setup_lines << current_transformer.transform_string("@tangible_thing = create(:scaffolding_completely_concrete_tangible_thing, #{previous_assignment})")

    setup_lines
  end

  def replace_in_file(file, before, after)
    puts "Replacing in '#{file}'."
    target_file_content = File.open(file).read
    target_file_content.gsub!(before, after)
    File.open(file, "w+") do |f|
      f.write(target_file_content)
    end
  end

  def restart_server
    # restart the server.
    puts "Restarting the server so it picks up the new localization .yml file."
    `./bin/rails restart`
  end

  def add_locale_helper_export_fix
    namespaced_locale_export_hook = "# 🚅 super scaffolding will insert the export for the locale view helper here."

    spacer = "  "
    indentation = spacer * 3
    namespace_elements = child.underscore.pluralize.split("/")
    last_element = namespace_elements.shift
    lines_to_add = [last_element + ":"]
    namespace_elements.map do |namespace_element|
      lines_to_add << indentation + namespace_element + ":"
      last_element = namespace_element
      indentation += spacer
    end
    lines_to_add << lines_to_add.pop + " *#{last_element}"

    scaffold_replace_line_in_file("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml", lines_to_add.join("\n"), namespaced_locale_export_hook)
  end

  def scaffold_new_breadcrumbs(child, parents)
    scaffold_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_breadcrumbs.html.erb")
    puts
    puts "Heads up! We're only able to generated the new breadcrumb views, so you'll have to edit `#{transform_string("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml")}` and add the label. You can look at `./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml` for an example of how to do this, but here's an example of what it should look like:".yellow
    puts
    puts transform_string("en:\n  scaffolding/completely_concrete/tangible_things: &tangible_things\n    label: &label Things\n    breadcrumbs:\n      label: *label").yellow
    puts
  end

  def add_attributes_to_various_views(attributes, local_options = {})
    sql_type_to_field_type_mapping = {
      # 'binary' => '',
      "boolean" => "buttons",
      "date" => "date_field",
      "datetime" => "date_and_time_field",
      "decimal" => "text_field",
      "float" => "text_field",
      "integer" => "text_field",
      "bigint" => "text_field",
      # 'primary_key' => '',
      # 'references' => '',
      "string" => "text_field",
      "text" => "text_area"
      # 'time' => '',
      # 'timestamp' => '',
    }

    # add attributes to various views.
    attributes.each_with_index do |attribute, index|
      first_table_cell = index == 0 && local_options[:type] == :crud

      cli_options = options.dup

      parts = attribute.split(":")
      name = parts.shift
      type = parts.join(":")
      boolean_buttons = type == "boolean"

      # extract any options they passed in with the field.
      type, attribute_options = type.scan(/^(.*)\[(.*)\]/).first || type

      # create a hash of the options.
      attribute_options = if attribute_options
        attribute_options.split(",").map { |s|
          option_name, option_value = s.split("=")
          [option_name.to_sym, option_value || true]
        }.to_h
      else
        {}
      end

      attribute_options[:label] ||= "label_string"

      if sql_type_to_field_type_mapping[type]
        type = sql_type_to_field_type_mapping[type]
      end

      is_id = name.match?(/_id$/)
      is_ids = name.match?(/_ids$/)
      # if this is the first attribute of a newly scaffolded model, that field is required.
      is_required = attribute_options[:required] || (local_options[:type] == :crud && index == 0)
      is_vanilla = attribute_options&.key?(:vanilla)
      is_belongs_to = is_id && !is_vanilla
      is_has_many = is_ids && !is_vanilla
      is_multiple = attribute_options&.key?(:multiple) || is_has_many
      is_association = is_belongs_to || is_has_many

      name_without_id = name.gsub(/_id$/, "")
      name_without_ids = name.gsub(/_ids$/, "").pluralize
      collection_name = is_ids ? name_without_ids : name_without_id.pluralize

      # field on the show view.
      attribute_partial ||= attribute_options[:attribute] || case type
      when "trix_editor", "ckeditor"
        "html"
      when "buttons", "super_select", "options"
        if boolean_buttons
          "boolean"
        elsif is_ids
          "has_many"
        elsif is_id
          "belongs_to"
        else
          "option"
        end
      when "cloudinary_image"
        options << "height: 200"
        "image"
      when "phone_field"
        "phone_number"
      when "date_field"
        "date"
      when "date_and_time_field"
        "date_and_time"
      when "email_field"
        "email"
      when "color_picker"
        "code"
      else
        "text"
      end

      cell_attributes = if boolean_buttons
        ' class="text-center"'
      end

      # e.g. from `person_id` to `person` or `person_ids` to `people`.
      attribute_name = if is_ids
        name_without_ids
      elsif is_id
        name_without_id
      else
        name
      end

      title_case = if is_ids
        # user_ids should be 'Users'
        name_without_ids.humanize.titlecase
      elsif is_id
        name_without_id.humanize.titlecase
      else
        name.humanize.titlecase
      end

      attribute_assignment = case type
      when "text_field", "password_field", "text_area"
        "'Alternative String Value'"
      when "email_field"
        "'another.email@test.com'"
      when "phone_field"
        "'+19053871234'"
      end

      # don't do table columns for certain types of fields and attribute partials
      if ["trix_editor", "ckeditor", "text_area"].include?(type) || ["html", "has_many"].include?(attribute_partial)
        cli_options["skip-table"] = true
      end

      if type == "none"
        cli_options["skip-form"] = true
      end

      if attribute_partial == "none"
        cli_options["skip-show"] = true
        cli_options["skip-table"] = true
      end

      #
      # MODEL VALIDATIONS
      #

      unless cli_options["skip-form"]

        file_name = "./app/models/scaffolding/completely_concrete/tangible_thing.rb"

        if is_association
          field_content = if attribute_options[:source]
            <<~RUBY
              def valid_#{collection_name}
                #{attribute_options[:source]}
              end

            RUBY
          else
            add_additional_step :yellow, transform_string("You'll need to implement the `valid_#{collection_name}` method of `Scaffolding::CompletelyConcrete::TangibleThing` in `./app/models/scaffolding/completely_concrete/tangible_thing.rb`. This is the method that will be used to populate the `#{type}` field and also validate that users aren't trying to exploit multitenancy.")

            <<~RUBY
              def valid_#{collection_name}
                raise "please review and implement `valid_#{collection_name}` in `app/models/scaffolding/completely_concrete/tangible_thing.rb`."
                # please specify what objects should be considered valid for assigning to `#{name_without_id}`.
                # the resulting code should probably look something like `team.#{collection_name}`.
              end

            RUBY
          end

          scaffold_add_line_to_file(file_name, field_content, METHODS_HOOK, prepend: true)

          if is_belongs_to
            scaffold_add_line_to_file(file_name, "validates :#{name_without_id}, scope: true", VALIDATIONS_HOOK, prepend: true)
          end

          # TODO we need to add a multitenancy check for has many associations.
        end

      end

      #
      # FORM FIELD
      #

      unless cli_options["skip-form"]

        # add `has_rich_text` for trix editor fields.
        if type == "trix_editor"
          file_name = "./app/models/scaffolding/completely_concrete/tangible_thing.rb"
          scaffold_add_line_to_file(file_name, "has_rich_text :#{name}", HAS_ONE_HOOK, prepend: true)
        end

        # field on the form.
        file_name = "./app/views/account/scaffolding/completely_concrete/tangible_things/_form.html.erb"
        field_attributes = {method: ":#{name}"}
        field_options = {}

        if local_options[:type] == :crud && index == 0
          field_options[:autofocus] = "true"
        end

        if is_id && type == "super_select"
          field_options[:include_blank] = "t('.fields.#{name}.placeholder')"
          # add_additional_step :yellow, transform_string("We've added a reference to a `placeholder` to the form for the select or super_select field, but unfortunately earlier versions of the scaffolded locales Yaml don't include a reference to `fields: *fields` under `form`. Please add it, otherwise your form won't be able to locate the appropriate placeholder label.")
        end

        if is_multiple
          field_options[:multiple] = "true"
        end

        if is_association
          # TODO validate this input before getting anywhere near here.
          unless attribute_options[:class_name]
            raise "you need to specify a class_name for #{name}, e.g. `#{name}:#{type}[class_name=SomeClassName]`"
          end
        end

        valid_values = if is_id
          "valid_#{name_without_id.pluralize}"
        elsif is_ids
          "valid_#{collection_name}"
        end

        # https://stackoverflow.com/questions/21582464/is-there-a-ruby-hashto-s-equivalent-for-the-new-hash-syntax
        if field_options.any?
          field_attributes[type == "buttons" ? :html_options : :options] = "{" + field_options.map { |key, value| "#{key}: #{value}" }.join(", ") + "}"
        end

        if is_association
          short = attribute_options[:class_name].underscore.split("/").last
          case type
          when "buttons", "options"
            field_attributes["\n  options"] = "@tangible_thing.#{valid_values}.map { |#{short}| [#{short}.id, #{short}.#{attribute_options[:label]}] }"
          when "super_select"
            field_attributes["\n  choices"] = "@tangible_thing.#{valid_values}.map { |#{short}| [#{short}.#{attribute_options[:label]}, #{short}.id] }"
          end
        end

        field_content = "<%= render 'shared/fields/#{type}'#{", " if field_attributes.any?}#{field_attributes.map { |key, value| "#{key}: #{value}" }.join(", ")} %>"
        scaffold_add_line_to_file(file_name, field_content, ERB_NEW_FIELDS_HOOK, prepend: true)
      end

      #
      # SHOW VIEW
      #

      unless cli_options["skip-show"]

        if is_id
          <<~ERB
            <% if @tangible_thing.#{name_without_id} %>
              <div class="form-group">
                <label class="col-form-label"><%= t('.fields.#{name}.heading') %></label>
                <div>
                  <%= link_to @tangible_thing.#{name_without_id}.#{attribute_options[:label]}, [:account, @tangible_thing.#{name_without_id}] %>
                </div>
              </div>
            <% end %>
          ERB
        elsif is_ids
          <<~ERB
            <% if @tangible_thing.#{collection_name}.any? %>
              <div class="form-group">
                <label class="col-form-label"><%= t('.fields.#{name}.heading') %></label>
                <div>
                  <%= @tangible_thing.#{collection_name}.map { |#{name_without_ids}| link_to #{name_without_ids}.#{attribute_options[:label]}, [:account, #{name_without_ids}] }.to_sentence.html_safe %>
                </div>
              </div>
            <% end %>
          ERB
        end

        # this gets stripped and is one line, so indentation isn't a problem.
        field_content = <<-ERB
          <%= render 'shared/attributes/#{attribute_partial}', attribute: :#{attribute_name} %>
        ERB

        scaffold_add_line_to_file("./app/views/account/scaffolding/completely_concrete/tangible_things/show.html.erb", field_content.strip, ERB_NEW_FIELDS_HOOK, prepend: true)

      end

      #
      # INDEX TABLE
      #

      unless cli_options["skip-table"]

        # table header.
        field_content = "<th #{cell_attributes}><%= t('.fields.#{attribute_name}.heading') %></th>"

        unless ["Team", "User"].include?(child)
          scaffold_add_line_to_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb", field_content, "<%# 🚅 super scaffolding will insert new field headers above this line. %>", prepend: true)
        end

        # table cell.
        options = []

        if first_table_cell
          options << "url: [:account, tangible_thing]"
        end

        # this gets stripped and is one line, so indentation isn't a problem.
        field_content = <<-ERB
          <td#{cell_attributes}><%= render 'shared/attributes/#{attribute_partial}', attribute: :#{attribute_name}#{", #{options.join(", ")}" if options.any?} %></td>
        ERB

        unless ["Team", "User"].include?(child)
          scaffold_add_line_to_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb", field_content.strip, ERB_NEW_FIELDS_HOOK, prepend: true)
        end

      end

      #
      # LOCALIZATIONS
      #

      unless cli_options["skip-locales"]

        yaml_template = <<~YAML

          <%= name %>: <% if is_association %>&<%= attribute_name %><% end %>
            _: &#{name} #{title_case}
            label: *#{name}
            heading: *#{name}

            <% if type == "super_select" %>
            <% if is_required %>
            placeholder: Select <% title_case.with_indefinite_article %>
            <% else %>
            placeholder: None
            <% end %>
            <% end %>

            <% if boolean_buttons %>

            options:
              yes: "Yes"
              no: "No"

            <% elsif ["buttons", "super_select", "options"].include?(type) && !is_association %>

            options:
              one: One
              two: Two
              three: Three

            <% end %>

          <% if is_association %>
          <%= attribute_name %>: *<%= attribute_name %>
          <% end %>
        YAML

        field_content = ERB.new(yaml_template).result(binding).lines.select(&:present?).join

        scaffold_add_line_to_file("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml", field_content, RUBY_NEW_FIELDS_HOOK, prepend: true)

        # active record's field label.
        scaffold_add_line_to_file("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml", "#{name}: *#{name}", "# 🚅 super scaffolding will insert new activerecord attributes above this line.", prepend: true)

      end

      #
      # STRONG PARAMETERS
      #

      unless cli_options["skip-form"]

        # add attributes to strong params.
        [
          "./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb"
        ].each do |file|
          if is_ids
            scaffold_add_line_to_file(file, "#{name}: [],", RUBY_NEW_ARRAYS_HOOK, prepend: true)
          else
            scaffold_add_line_to_file(file, ":#{name},", RUBY_NEW_FIELDS_HOOK, prepend: true)
          end
        end

        special_processing = case type
        when "date_field"
          "assign_date(strong_params, :#{name})"
        when "date_and_time_field"
          "assign_date_and_time(strong_params, :#{name})"
        when "buttons"
          if boolean_buttons
            "assign_boolean(strong_params, :#{name})"
          elsif is_multiple
            "assign_checkboxes(strong_params, :#{name})"
          end
        when "super_select"
          if boolean_buttons
            "assign_boolean(strong_params, :#{name})"
          elsif is_multiple
            "assign_select_options(strong_params, :#{name})"
          end
        end

        scaffold_add_line_to_file("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb", special_processing, RUBY_NEW_FIELDS_PROCESSING_HOOK, prepend: true) if special_processing

      end

      #
      # API ENDPOINT
      #

      unless cli_options["skip-api"]

        # add attributes to endpoint.
        if name.match?(/_ids$/)
          scaffold_add_line_to_file("./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint.rb", "optional :#{name}, type: Array, desc: Api.heading(:#{name})", RUBY_NEW_ARRAYS_HOOK, prepend: true)
        else
          api_type = case type
          when "date_field"
            "Date"
          when "date_and_time_field"
            "DateTime"
          when "buttons"
            if boolean_buttons
              "Boolean"
            else
              "String"
            end
          when "file_field"
            "File"
          else
            "String"
          end

          scaffold_add_line_to_file("./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint.rb", "optional :#{name}, type: #{api_type}, desc: Api.heading(:#{name})", RUBY_NEW_FIELDS_HOOK, prepend: true)
        end

      end

      #
      # API SERIALIZER
      #

      unless cli_options["skip-api"]

        # TODO The serializers can't handle these `has_rich_text` attributes.
        unless type == "trix_editor"
          [
            "./app/views/account/scaffolding/completely_concrete/tangible_things/_tangible_thing.json.jbuilder",
            "./app/serializers/api/v1/scaffolding/completely_concrete/tangible_thing_serializer.rb"
          ].each do |file|
            scaffold_add_line_to_file(file, ":#{name},", RUBY_NEW_FIELDS_HOOK, prepend: true)
          end

          scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint_test.rb", "assert_equal tangible_thing_data['#{name}'], tangible_thing.#{name}", RUBY_NEW_FIELDS_HOOK, prepend: true)
        end

        # scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller_test.rb", "assert_equal tangible_thing_attributes['#{name.gsub('_', '-')}'], tangible_thing.#{name}", RUBY_NEW_FIELDS_HOOK, prepend: true)

        if attribute_assignment
          scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint_test.rb", "#{name}: #{attribute_assignment},", RUBY_ADDITIONAL_NEW_FIELDS_HOOK, prepend: true)
          scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint_test.rb", "assert_equal @tangible_thing.#{name}, #{attribute_assignment}", RUBY_EVEN_MORE_NEW_FIELDS_HOOK, prepend: true)
        end
      end

      #
      # MODEL ASSOCATIONS
      #

      unless cli_options["skip-model"]

        if is_belongs_to
          unless attribute_options[:class_name]
            attribute_options[:class_name] = name_without_id.classify
          end

          file_name = "app/models/#{attribute_options[:class_name].underscore}.rb"
          unless File.exist?(file_name)
            raise "You'll need to specify a `class_name` option for `#{name}` because there is no `#{attribute_options[:class_name].classify}` model defined in `#{file_name}`. Try again with `#{name}:#{type}[class_name=SomeClassName]`."
          end

          modified_migration = false

          # find the database migration that defines this relationship.
          expected_reference = "add_reference :#{class_names_transformer.table_name}, :#{name_without_id}"
          migration_file_name = `grep "#{expected_reference}" db/migrate/*`.split(":").first

          # if that didn't work, see if we can find a creation of the reference when the table was created.
          unless migration_file_name
            confirmation_reference = "create_table :#{class_names_transformer.table_name}"
            confirmation_migration_file_name = `grep "#{confirmation_reference}" db/migrate/*`.split(":").first

            fallback_reference = "t.references :#{name_without_id}"
            fallback_migration_file_name = `grep "#{fallback_reference}" db/migrate/* | grep #{confirmation_migration_file_name}`.split(":").first

            if fallback_migration_file_name == confirmation_migration_file_name
              migration_file_name = fallback_migration_file_name
            end
          end

          unless is_required

            if migration_file_name
              replace_in_file(migration_file_name, ":#{name_without_id}, null: false", ":#{name_without_id}, null: true")
              modified_migration = true
            else
              add_additional_step :yellow, "We would have expected there to be a migration that defined `#{expected_reference}`, but we didn't find one. Where was the reference added to this model? It's _probably_ the original creation of the table, but we couldn't find that either. Either way, you need to rollback, change 'null: false' to 'null: true' for this column, and re-run the migration (unless, of course, that attribute _is_ required, then you need to add a validation on the model)."
            end

          end

          class_name_matches = name_without_id.tableize == attribute_options[:class_name].tableize.tr("/", "_")

          # but also, if namespaces are involved, just don't...
          if attribute_options[:class_name].include?("::")
            class_name_matches = false
          end

          # unless the table name matches the association name.
          unless class_name_matches

            if migration_file_name
              replace_in_file(migration_file_name, "foreign_key: true", "foreign_key: {to_table: '#{attribute_options[:class_name].tableize.tr("/", "_")}'}")
              # TODO also solve the 60 character long index limitation.
              modified_migration = true
            else
              add_additional_step :yellow, "We would have expected there to be a migration that defined `#{expected_reference}`, but we didn't find one. Where was the reference added to this model? It's _probably_ the original creation of the table. Either way, you need to rollback, change \"foreign_key: true\" to \"foreign_key: {to_table: '#{attribute_options[:class_name].tableize.tr("/", "_")}'}\" for this column, and re-run the migration."
            end

          end

          optional_line = ", optional: true" unless is_required

          # if the `belongs_to` is already there from `rails g model`..
          scaffold_replace_line_in_file(
            "./app/models/scaffolding/completely_concrete/tangible_thing.rb",
            class_name_matches ?
              "belongs_to :#{name_without_id}#{optional_line}" :
              "belongs_to :#{name_without_id}, class_name: '#{attribute_options[:class_name]}'#{optional_line}",
            "belongs_to :#{name_without_id}"
          )

          # if it wasn't there, the replace will not have done anything, so we insert it entirely.
          # however, this won't do anything if the association is already there.
          scaffold_add_line_to_file(
            "./app/models/scaffolding/completely_concrete/tangible_thing.rb",
            class_name_matches ?
              "belongs_to :#{name_without_id}#{optional_line}" :
              "belongs_to :#{name_without_id}, class_name: '#{attribute_options[:class_name]}'#{optional_line}",
            BELONGS_TO_HOOK,
            prepend: true
          )

          if modified_migration
            add_additional_step :yellow, "If you've already run the migration in `#{migration_file_name}`, you'll need to roll back and run it again."
          end
        end

      end

      #
      # MODEL HOOKS
      #

      unless cli_options["skip-model"]

        if is_required && !is_belongs_to
          scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "validates :#{name}, presence: true", VALIDATIONS_HOOK, prepend: true)
        end

        case type
        when "file_field"
          scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "has_one_attached :#{name}", HAS_ONE_HOOK, prepend: true)
        when "trix_editor"
          scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "has_rich_text :#{name}", HAS_ONE_HOOK, prepend: true)
        end

      end
    end
  end

  def add_additional_step(color, message)
    additional_steps.push [color, message]
  end

  def scaffold_crud(attributes)
    if options["only-index"]
      options["skip-table"] = false
      options["skip-views"] = true
      options["skip-controller"] = true
      options["skip-form"] = true
      options["skip-show"] = true
      options["skip-form"] = true
      options["skip-api"] = true
      options["skip-model"] = true
      options["skip-parent"] = true
      options["skip-locales"] = true
      options["skip-routes"] = true
    end

    # TODO fix this. we can do this better.
    files = if options["only-index"]
      [
        "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb",
        "./app/views/account/scaffolding/completely_concrete/tangible_things/index.html.erb"
      ]
    else
      # copy a ton of files over and do the appropriate string replace.
      [
        "./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb",
        "./app/views/account/scaffolding/completely_concrete/tangible_things",
        "./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml",
        "./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint.rb",
        "./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint_test.rb",
        "./app/serializers/api/v1/scaffolding/completely_concrete/tangible_thing_serializer.rb",
        # "./app/filters/scaffolding/completely_concrete/tangible_things_filter.rb"
      ]
    end

    files.each do |name|
      if File.directory?(name)
        scaffold_directory(name)
      else
        scaffold_file(name)
      end
    end

    unless options["skip-api"]

      # add endpoint to the api.
      scaffold_add_line_to_file("./app/controllers/api/v1/root.rb", "mount Api::V1::Scaffolding::CompletelyConcrete::TangibleThingsEndpoint", ENDPOINTS_HOOK, prepend: true)

    end

    unless options["skip-model"]

      # update the factory generated by `rails g`.
      content = if transform_string(":absolutely_abstract_creative_concept") == transform_string(":scaffolding_absolutely_abstract_creative_concept")
        transform_string("association :absolutely_abstract_creative_concept")
      else
        transform_string("association :absolutely_abstract_creative_concept, factory: :scaffolding_absolutely_abstract_creative_concept")
      end
      scaffold_replace_line_in_file("./test/factories/scaffolding/completely_concrete/tangible_things.rb", content, "absolutely_abstract_creative_concept { nil }")

      # if needed, update the reference to the parent class name in the create_table migration.
      current_transformer = Scaffolding::ClassNamesTransformer.new(child, parent)
      unless current_transformer.parent_variable_name_in_context.pluralize == current_transformer.parent_table_name

        # find the database migration that defines this relationship.
        migration_file_name = `grep "create_table :#{class_names_transformer.table_name} do |t|" db/migrate/*`.split(":").first
        unless migration_file_name.present?
          raise "No migration file seems to exist for creating the table `#{class_names_transformer.table_name}`"
        end

        replace_in_file(migration_file_name, "foreign_key: true", "foreign_key: {to_table: '#{current_transformer.parent_table_name}'}")
      end

      # TODO remove the class_name if not needed.
      scaffold_add_line_to_file("./app/models/scaffolding/absolutely_abstract/creative_concept.rb", "has_many :completely_concrete_tangible_things, class_name: 'Scaffolding::CompletelyConcrete::TangibleThing', dependent: :destroy, foreign_key: :absolutely_abstract_creative_concept_id", HAS_MANY_HOOK, prepend: true)

      if class_names_transformer.belongs_to_needs_class_definition?
        scaffold_replace_line_in_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", transform_string("belongs_to :absolutely_abstract_creative_concept, class_name: 'Scaffolding::AbsolutelyAbstract::CreativeConcept'\n"), transform_string("belongs_to :absolutely_abstract_creative_concept\n"))
      end

      # add user permissions.
      ability_line, admin_ability_line = build_ability_line
      if admin_ability_line
        add_line_to_file("./app/models/ability.rb", ability_line, "# the following admin abilities were added by super scaffolding.")
      else
        add_line_to_file("./app/models/ability.rb", ability_line, "# the following abilities were added by super scaffolding.")
      end
    end

    scaffold_replace_line_in_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_endpoint_test.rb", build_factory_setup.join("\n"), "# 🚅 super scaffolding will insert factory setup in place of this line.")

    # add children to the show page of their parent.
    unless options["skip-parent"] || parent == "None"
      scaffold_add_line_to_file("./app/views/account/scaffolding/absolutely_abstract/creative_concepts/show.html.erb", "<%= render 'account/scaffolding/completely_concrete/tangible_things/index', tangible_things: @creative_concept.completely_concrete_tangible_things#{".in_sort_order" if options["sortable"]}, hide_back: true %>", "<%# 🚅 super scaffolding will insert new children above this line. %>", prepend: true)
    end

    unless options["skip-model"]

      before_scaffolding_hooks = <<~RUBY
        #{CONCERNS_HOOK}

      RUBY

      after_scaffolding_hooks = <<-RUBY
        #{BELONGS_TO_HOOK}

        #{HAS_MANY_HOOK}

        #{HAS_ONE_HOOK}

        #{SCOPES_HOOK}

        #{VALIDATIONS_HOOK}

        #{CALLBACKS_HOOK}

        #{DELEGATIONS_HOOK}

        #{METHODS_HOOK}
      RUBY

      # add scaffolding hooks to the model.
      unless File.readlines(transform_string("./app/models/scaffolding/completely_concrete/tangible_thing.rb")).join.include?(CONCERNS_HOOK)
        scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", before_scaffolding_hooks, "ApplicationRecord", increase_indent: true)
      end

      unless File.readlines(transform_string("./app/models/scaffolding/completely_concrete/tangible_thing.rb")).join.include?(BELONGS_TO_HOOK)
        scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", after_scaffolding_hooks, "end", prepend: true, increase_indent: true, exact_match: true)
      end

    end

    #
    # DELEGATIONS
    #

    unless options["skip-model"]

      if ["Team", "User"].include?(parents.last) && parent != parents.last
        scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "delegate :#{parents.last.underscore}, to: :absolutely_abstract_creative_concept", DELEGATIONS_HOOK, prepend: true)
      end

    end

    add_attributes_to_various_views(attributes, type: :crud)

    unless options["skip-locales"]
      add_locale_helper_export_fix
    end

    # add sortability.
    if options["sortable"]
      unless options["skip-model"]
        scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "def collection\n    absolutely_abstract_creative_concept.completely_concrete_tangible_things\n  end\n", METHODS_HOOK, prepend: true)
        scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "include Sprinkles::Sortable\n", CONCERNS_HOOK, prepend: true)
      end

      unless options["skip-table"]
        scaffold_replace_line_in_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb", transform_string("<tbody data-reorder=\"<%= url_for [:reorder, :account, context, collection] %>\">"), "<tbody>")
      end

      unless options["skip-controller"]
        scaffold_add_line_to_file("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb", "include Sprinkles::SortableActions\n", "Account::ApplicationController", increase_indent: true)
      end
    end

    # titleize the localization file.
    unless options["skip-locales"]
      replace_in_file(transform_string("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml"), child, child.underscore.humanize.titleize)
    end

    # apply routes.
    unless options["skip-routes"]
      routes_manipulator = Scaffolding::RoutesFileManipulator.new("config/routes.rb", child, parent)
      begin
        routes_manipulator.apply(["account"])
      rescue
        add_additional_step :yellow, "We weren't able to automatically add your `account` routes for you. In theory this should be very rare, so if you could reach out on Slack, you could probably provide context that will help us fix whatever the problem was. In the meantime, to add the routes manually, we've got a guide at https://blog.bullettrain.co/nested-namespaced-rails-routing-examples/ ."
      end

      # begin
      #   routes_manipulator.apply(['api', 'v1'])
      # rescue
      #   add_additional_step :yellow, "We weren't able to automatically add your `api/v1` routes for you. In theory this should be rare, (unless you're adding a resource under another resource that specifically don't have API routes,) so if you could reach out on Slack, you could probably provide context that will help us fix whatever the problem was. In the meantime, to add the routes manually, we've got a guide at https://blog.bullettrain.co/nested-namespaced-rails-routing-examples/ ."
      # end

      routes_manipulator.write
    end

    unless options["skip-parent"]

      if parent == "Team" || parent == "None"
        icon_name = nil
        if options["sidebar"].present?
          icon_name = options["sidebar"]
        else
          puts ""
          puts "Hey, models that are scoped directly off of a Team (or nothing) are eligible to be added to the sidebar. Do you want to add this resource to the sidebar menu? (y/N)"
          response = $stdin.gets.chomp
          if response.downcase[0] == "y"
            puts ""
            puts "OK, great! Let's do this! By default these menu items appear with a puzzle piece, but after you hit enter I'll open two different pages where you can view other icon options. When you find one you like, hover your mouse over it and then come back here and and enter the name of the icon you want to use. (Or hit enter to skip this step.)"
            $stdin.gets.chomp
            if `which open`.present?
              `open https://themify.me/themify-icons`
              `open https://fontawesome.com/icons?d=gallery&s=light`
            else
              puts "Sorry! We can't open these URLs automatically on your platform, but you can visit them manually:"
              puts ""
              puts "  https://themify.me/themify-icons"
              puts "  https://fontawesome.com/icons?d=gallery&s=light"
              puts ""
            end
            puts ""
            puts "Did you find an icon you wanted to use? Enter the full CSS class here (e.g. 'ti ti-globe' or 'fal fa-puzzle-piece') or hit enter to just use the puzzle piece:"
            icon_name = $stdin.gets.chomp
            puts ""
            unless icon_name.length > 0 || icon_name.downcase == "y"
              icon_name = "fal fa-puzzle-piece ti ti-gift"
            end
          end
        end
        if icon_name.present?
          replace_in_file(transform_string("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml"), "fal fa-puzzle-piece", icon_name)
          scaffold_add_line_to_file("./app/views/account/shared/_menu.html.erb", "<%= render 'account/scaffolding/completely_concrete/tangible_things/menu_item' %>", "<% # added by super scaffolding. %>")
        end
      end

    end

    restart_server
  end
end
