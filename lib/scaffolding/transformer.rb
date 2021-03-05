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
  ERB_NEW_FIELDS_HOOK = "<%#{RUBY_NEW_FIELDS_HOOK} %>"
  CONCERNS_HOOK = "# 🚅 add concerns above."
  BELONGS_TO_HOOK = "# 🚅 add belongs_to associations above."
  HAS_MANY_HOOK = "# 🚅 add has_many associations above."
  OAUTH_PROVIDERS_HOOK = "# 🚅 add oauth providers above."
  HAS_ONE_HOOK = "# 🚅 add has_one associations above."
  SCOPES_HOOK = "# 🚅 add scopes above."
  VALIDATIONS_HOOK = "# 🚅 add validations above."
  CALLBACKS_HOOK = "# 🚅 add callbacks above."
  METHODS_HOOK = "# 🚅 add methods above."

  def encode_double_replacement_fix(string)
    string.split("").join("~!@BT@!~")
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
    transformed_file_name = transform_string(file)

    transformed_file_content = []

    skipping = false
    gathering_lines_to_repeat = false
    repeat_for_each_parent = false

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
        if options[:exact_match] ? line == transformed_after : line.match(/#{Regexp.escape(transformed_after)}\s*$/)

          if add_before
            new_target_file_content << "#{line} #{add_before}"
          else
            unless options[:prepend]
              new_target_file_content << line
            end
          end

          # get leading whitespace.
          line =~ /^(\s*).*#{Regexp.escape(transformed_after)}.*/
          leading_whitespace = $1
          new_target_file_content << "#{leading_whitespace}#{"  " if increase_indent}#{transformed_content}"

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

    admin_ability_line = false

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

    last_parent = current_parent
    last_transformer = current_transformer
    current_parent = working_parents.pop

    while current_parent
      current_transformer = Scaffolding::Transformer.new(working_parents.last || class_name, [current_parent])
      setup_lines << current_transformer.transform_string("@absolutely_abstract_creative_concept = create(:scaffolding_absolutely_abstract_creative_concept, #{previous_assignment})")
      previous_assignment = current_transformer.transform_string("absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept")

      last_parent = current_parent
      last_transformer = current_transformer
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
    puts ("Heads up! We're only able to generated the new breadcrumb views, so you'll have to edit `#{transform_string("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml")}` and add the label. " +
      "You can look at `./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml` for an example of how to do this, but here's an example of what it should look like:").yellow
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

      parts = attribute.split(":")
      name = parts.shift
      type = parts.join(":")

      # extract any options they passed in with the field.
      type, attribute_options = type.scan(/^(.*)\[(.*)\]/).first || type

      # create a hash of the options.
      attribute_options = if attribute_options
        attribute_options.split(",").map do |s|
          option_name, option_value = s.split("=")
          [option_name.to_sym, option_value || true]
        end.to_h
      else
        {}
      end

      attribute_options[:label] ||= "label_string"

      # if this is the first attribute of a newly scaffolded model, that field is required.
      if local_options[:type] == :crud && index == 0
        attribute_options[:required] = true
      end

      if sql_type_to_field_type_mapping[type]
        if type == "boolean"
          boolean_buttons = true
          buttons_options = {
            "true" => '"Yes"',
            "false" => '"No"'
          }
        end
        type = sql_type_to_field_type_mapping[type]
      end

      if name.match?(/_id$/) && !attribute_options&.key(:vanilla)
        name_without_id = name.gsub(/_id$/, "")
        field_content = <<~RUBY
          def valid_#{name_without_id.pluralize}
              raise "please review and implement `valid_#{name_without_id.pluralize}` in `app/models/scaffolding/completely_concrete/tangible_thing.rb`."
              # please specify what objects should be considered valid for assigning to `#{name_without_id}`.
              # this will be used to populate any form field options and for validation below.
              # the resulting code should probably look something like `team.collection_name`.
            end
          
            def validate_#{name_without_id}
              if #{name}.present?
                # don't allow users to assign the ids of other teams' or users' resources to this attribute.
                unless valid_#{name_without_id.pluralize}.ids.include?(#{name})
                  errors.add(:#{name}, :invalid)
                end
              end
            end
        RUBY

        file_name = "./app/models/scaffolding/completely_concrete/tangible_thing.rb"
        scaffold_add_line_to_file(file_name, field_content, METHODS_HOOK, prepend: true)
        scaffold_add_line_to_file(file_name, "validate :validate_#{name_without_id}", VALIDATIONS_HOOK, prepend: true)
        add_additional_step :yellow, transform_string("You'll need to implement the `valid_#{name_without_id.pluralize}` method of `Scaffolding::CompletelyConcrete::TangibleThing` in `./app/models/scaffolding/completely_concrete/tangible_thing.rb`. This is the method that will be used to populate the `#{type}` field and also validate that users aren't trying to exploit multitenancy.")

      elsif name.match?(/_ids$/) && !attribute_options&.key(:vanilla)
        collection_name = name.gsub(/_ids$/, "").pluralize
        field_content = <<~RUBY
          def valid_#{collection_name}
              raise "please review and implement `valid_#{collection_name}` in `scaffolding/completely_concrete/tangible_thing.rb`."
              # please specify what objects should be considered valid for assigning to `#{collection_name}`.
              # this will be used to any form field options. the resulting code should probably look something
              # like `team.collection_name`.
            end
        RUBY

        file_name = "./app/models/scaffolding/completely_concrete/tangible_thing.rb"
        scaffold_add_line_to_file(file_name, field_content, METHODS_HOOK, prepend: true)
        add_additional_step :yellow, transform_string("You'll need to implement the `valid_#{collection_name}` method of `Scaffolding::CompletelyConcrete::TangibleThing` in `./app/models/scaffolding/completely_concrete/tangible_thing.rb`. This is the method that will be used to populate the `#{type}` field and also validate that users aren't trying to exploit multitenancy.")
      end

      # field on the form.
      file_name = "./app/views/account/scaffolding/completely_concrete/tangible_things/_form.html.erb"
      unless attribute_options&.key(:vanilla)
        options_need_defining = name.match?(/_id$/) || name.match?(/_ids$/)
      end
      field_options = []
      if local_options[:type] == :crud && index == 0
        field_options << "autofocus: true"
      end
      if name.match?(/_id$/) && ["select", "super_select"].include?(type)
        field_options << "include_blank: t('.fields.#{name}.placeholder')"
        add_additional_step :yellow, transform_string("We've added a reference to a `placeholder` to the form for the select or super_select field, but unfortunately earlier versions of the scaffolded locales Yaml don't include a reference to `fields: *fields` under `form`. Please add it, otherwise your form won't be able to locate the appropriate placeholder label.")
      end

      if name.match?(/_id$/) || name.match?(/_ids$/)
        # TODO validate this input before getting anywhere near here.
        unless attribute_options[:class_name]
          raise "you need to specify a class_name for #{name}, e.g. `#{name}:#{type}[class_name=SomeClassName]`"
        end
      end

      if name.match?(/_id$/) || name.match?(/_ids$/)
        # TODO validate this input before getting anywhere near here.
        unless attribute_options[:class_name]
          raise "you need to specify a class_name for #{name}, e.g. `#{name}:#{type}[class_name=SomeClassName]`"
        end
      end

      short = attribute_options[:class_name].underscore.split("/").last if options_need_defining

      choices = case type
      when "select", "super_select"
        "choices"
      when "buttons"
        "options"
      end

      valid_values = if name.match?(/_id$/)
        "valid_#{name_without_id.pluralize}"
      elsif name.match?(/_ids$/)
        "valid_#{collection_name}"
      end

      field_attributes = {
        method: ":#{name}"
      }

      if name.match?(/_ids$/)
        field_attributes[:html_options] = "{multiple: true}"
      end

      if field_options.any?
        field_attributes[:options] = "{#{field_options.join(", ")}}"
      end

      if options_need_defining
        case type
        when "buttons"
          field_attributes["\n    options"] = "@tangible_thing.#{valid_values}.map { |#{short}| [#{short}.id, #{short}.#{attribute_options[:label]}] }"
        when "select", "super_select"
          field_attributes["\n    choices"] = "@tangible_thing.#{valid_values}.map { |#{short}| [#{short}.#{attribute_options[:label]}, #{short}.id] }"
        end
      end

      field_content = "<%= render 'shared/fields/#{type}', #{field_attributes.map { |key, value| "#{key}: #{value}" }.join(", ")} %>"

      scaffold_add_line_to_file(file_name, field_content, ERB_NEW_FIELDS_HOOK, prepend: true)

      field_content = if name.match?(/_id$/)
        name_without_id = name.gsub(/_id$/, "")
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
      elsif name.match?(/_ids$/)
        name_without_ids = name.gsub("_ids", "")
        <<~ERB
          <% if @tangible_thing.#{name_without_ids.pluralize}.any? %>
                  <div class="form-group">
                    <label class="col-form-label"><%= t('.fields.#{name}.heading') %></label>
                    <div>
                      <%= @tangible_thing.#{name_without_ids.pluralize}.map { |#{name_without_ids}| link_to #{name_without_ids}.#{attribute_options[:label]}, [:account, #{name_without_ids}] }.to_sentence.html_safe %>
                    </div>
                  </div>
                <% end %>
        ERB
      end

      # field on the show view.
      attribute_partial ||= case type
      when "trix_editor", "ckeditor"
        "html"
      when "buttons", "select", "super_select"
        if boolean_buttons
          "boolean"
        else
          "option"
        end
      when "cloudinary_image"
        "image"
      when "phone_field"
        "phone_number"
      when "date_field"
        "date"
      when "date_and_time_field"
        "date_and_time"
      when "email_field"
        "email"
      else
        "text"
      end

      # this gets stripped and is one line, so indentation isn't a problem.
      field_content = <<-ERB
        <%= render 'shared/attributes/#{attribute_partial}', attribute: :#{name} %>
      ERB

      scaffold_add_line_to_file("./app/views/account/scaffolding/completely_concrete/tangible_things/show.html.erb", field_content.strip, ERB_NEW_FIELDS_HOOK, prepend: true)

      # field on the index table.
      unless options["skip-table"]
        unless ["trix_editor", "ckeditor", "text_area"].include?(type)

          # table header.
          cell_attributes = boolean_buttons ? ' class="text-center"' : nil
          field_content = "<th#{cell_attributes}><%= t('.fields.#{name}.heading') %></th>"

          unless ["Team", "User"].include?(child)
            scaffold_add_line_to_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb", field_content, "<%# 🚅 super scaffolding will insert new field headers above this line. %>", prepend: true)
          end

          # table cell.
          options = []

          # are there any special options to pass into the attribute partial because we're displaying this in a table?
          case type
          when "cloudinary_image"
            options << "height: 200"
          end

          if first_table_cell
            options << "url: [:account, tangible_thing]"
          end

          name_without_id = name.gsub(/_id$/, "")

          # this gets stripped and is one line, so indentation isn't a problem.
          field_content = <<-ERB
            <td#{cell_attributes}><%= render 'shared/attributes/#{attribute_partial}', attribute: :#{name_without_id}#{", #{options.join(", ")}" if options.any?} %></td>
          ERB

          unless ["Team", "User"].include?(child)
            scaffold_add_line_to_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb", field_content.strip, ERB_NEW_FIELDS_HOOK, prepend: true)
          end
        end
      end

      title_case = if name.match?(/_ids$/)
        # user_ids should be 'Users'
        name.gsub(/_ids$/, "").humanize.titlecase.pluralize
      else
        name.humanize.titlecase
      end

      # localizations for this field.

      field_content = nil

      if name.match?(/_id$/) &&
          if ["select", "super_select"].include?(type)
            placeholder_text = if attribute_options[:required]
              "Select a #{attribute_options[:class_name].split("::").last.titlecase}"
            else
              "None"
            end

            field_content = <<~YAML
              #{name}:
                      _: &#{name} #{title_case}
                      label: *#{name}
                      heading: *#{name}
                      placeholder: #{placeholder_text}
            YAML
          end
      elsif !name.match?(/_ids$/)
        if ["buttons", "select", "super_select"].include?(type)

          yaml_options = if boolean_buttons
            # this does the same output as the yaml right below.
            buttons_options.map { |key, value| "#{key}: #{value}" }.join("\n          ")
          else
            <<~YAML
              one: One
                        two: Two
                        three: Three
            YAML
          end

          field_content = <<~YAML
            #{name}:
                    _: &#{name} #{title_case}
                    label: *#{name}
                    heading: *#{name}
                    options:
                      #{yaml_options}
          YAML
        end
      end

      field_content ||= <<~YAML
        #{name}:
                _: &#{name} #{title_case}
                label: *#{name}
                heading: *#{name}
      YAML

      scaffold_add_line_to_file("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml", field_content, RUBY_NEW_FIELDS_HOOK, prepend: true)

      # active record's field label.
      scaffold_add_line_to_file("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml", "#{name}: *#{name}", "# 🚅 super scaffolding will insert new activerecord attributes above this line.", prepend: true)

      # add attributes to strong params.
      [
        "./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb"
        # "./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller.rb",
      ].each do |file|
        if name.match?(/_ids$/)
          scaffold_add_line_to_file(file, "#{name}: [],", RUBY_NEW_ARRAYS_HOOK, prepend: true)
        else
          scaffold_add_line_to_file(file, ":#{name},", RUBY_NEW_FIELDS_HOOK, prepend: true)
        end
      end

      case type
      when "date_field"
        scaffold_add_line_to_file("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb", "assign_date(strong_params, :#{name})", RUBY_NEW_FIELDS_PROCESSING_HOOK, prepend: true)
      when "date_and_time_field"
        scaffold_add_line_to_file("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb", "assign_date_and_time(strong_params, :#{name})", RUBY_NEW_FIELDS_PROCESSING_HOOK, prepend: true)
      when "buttons"
        if boolean_buttons
          scaffold_add_line_to_file("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb", "assign_boolean(strong_params, :#{name})", RUBY_NEW_FIELDS_PROCESSING_HOOK, prepend: true)
        end
      end

      [
        "./app/views/account/scaffolding/completely_concrete/tangible_things/_tangible_thing.json.jbuilder",
        "./app/serializers/api/v1/scaffolding/completely_concrete/tangible_thing_serializer.rb"
      ].each do |file|
        scaffold_add_line_to_file(file, ":#{name},", RUBY_NEW_FIELDS_HOOK, prepend: true)
      end

      # scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller_test.rb", "assert_equal tangible_thing_attributes['#{name.gsub('_', '-')}'], tangible_thing.#{name}", RUBY_NEW_FIELDS_HOOK, prepend: true)

      attribute_assignment = case type
      when "text_field", "password_field", "text_area"
        "'Alternative String Value'"
      when "email_field"
        "'another.email@test.com'"
      when "phone_field"
        "'+19053871234'"
      end

      if attribute_assignment
        # scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller_test.rb", "#{name}: #{attribute_assignment},", RUBY_ADDITIONAL_NEW_FIELDS_HOOK, prepend: true)
        # scaffold_add_line_to_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller_test.rb", "assert_equal @tangible_thing.#{name}, #{attribute_assignment}", RUBY_EVEN_MORE_NEW_FIELDS_HOOK, prepend: true)
      end

      scaffold_add_line_to_file("./test/controllers/account/scaffolding/completely_concrete/tangible_things_controller_test.rb", "#{name}: @tangible_thing.#{name},", RUBY_NEW_FIELDS_HOOK, prepend: true)
      # because we're inserting the same content into the file twice, we have to do both of these steps.
      scaffold_add_line_to_file("./test/controllers/account/scaffolding/completely_concrete/tangible_things_controller_test.rb", "#{name}: @tangible_thing.#{name}, # this can be removed after scaffolding.", RUBY_ADDITIONAL_NEW_FIELDS_HOOK, prepend: true)
      replace_in_file(transform_string("./test/controllers/account/scaffolding/completely_concrete/tangible_things_controller_test.rb"), " # this can be removed after scaffolding.", "")

      if name.match?(/_id$/) && !attribute_options&.key(:vanilla)
        name_without_id = name.gsub(/_id$/, "")
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

        unless attribute_options[:required]

          if migration_file_name
            replace_in_file(migration_file_name, "null: false", "null: true")
            modified_migration = true
          else
            add_additional_step :yellow, "We would have expected there to be a migration that defined `#{expected_reference}`, but we didn't find one. Where was the reference added to this model? It's _probably_ the original creation of the table. Either way, you need to rollback, change 'null: false' to 'null: true' for this column, and re-run the migration (unless, of course, that attribute _is_ required, then you need to add a validation on the model)."
          end

        end

        class_name_matches = name_without_id.tableize == attribute_options[:class_name].tableize.tr("/", "_")

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

        optional_line = ", optional: true" unless attribute_options[:required]

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
      elsif attribute_options[:required]

        # if it's not a reference, then we need to add a validation for required fields specifically.
        scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "validates :#{name}, presence: true", VALIDATIONS_HOOK, prepend: true)

      end
    end
  end

  def add_additional_step(color, message)
    additional_steps.push [color, message]
  end

  # def scaffold_route
  #   # Thing
  #   child_class_name = child.classify
  #
  #   # things
  #   child_variable_name_plural = child_class_name.tableize
  #
  #   # Team
  #   parent_class_name = parent.classify
  #
  #   # teams
  #   parent_variable_name_plural = parent_class_name.tableize
  #
  #   routes_content = File.open('./config/routes.rb').read
  #
  #   resources_things = "resources :things" + (options['sortable'] ? ', concerns: [:sortable]' : '')
  #   if parent_class_name == 'Team'
  #     scaffold_add_line_to_file('./config/routes.rb', resources_things, "# the following routes were added by super scaffolding.")
  #     scaffold_add_line_to_file('./config/routes.rb', "resources :things, only: api_actions", "# the following api routes were added by super scaffolding.")
  #   elsif routes_content.include?(transform_string("resources :teams do"))
  #     scaffold_add_line_to_file('./config/routes.rb', resources_things, "resources :teams do", increase_indent: true)
  #     scaffold_add_line_to_file('./config/routes.rb', "resources :things, only: api_actions", "resources :teams, only: api_actions do", increase_indent: true)
  #   elsif routes_content.include?(transform_string("resources :teams"))
  #     scaffold_add_line_to_file('./config/routes.rb', resources_things, "resources :teams", increase_indent: true, add_before: 'do', add_after: 'end')
  #     scaffold_add_line_to_file('./config/routes.rb', "resources :things, only: api_actions", "resources :teams, only: api_actions", increase_indent: true, add_before: 'do', add_after: 'end')
  #   else
  #     puts "!! Couldn't automatically add routes. Couldn't find `resources :#{parent_variable_name_plural}`"
  #   end
  # end

  def scaffold_crud(attributes)
    # copy a ton of files over and do the appropriate string replace.
    [
      "./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb",
      "./app/views/account/scaffolding/completely_concrete/tangible_things",
      "./test/controllers/account/scaffolding/completely_concrete/tangible_things_controller_test.rb",
      "./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml",
      # "./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller.rb",
      # "./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller_test.rb",
      "./app/serializers/api/v1/scaffolding/completely_concrete/tangible_thing_serializer.rb"
      # "./app/views/public/home/api/scaffolding/completely_concrete/_tangible_things.html.erb",
    ].each do |name|
      if File.directory?(name)
        scaffold_directory(name)
      else
        scaffold_file(name)
      end
    end

    # if needed, update the reference to the parent class name in the create_table migration.
    modified_migration = false
    current_transformer = Scaffolding::ClassNamesTransformer.new(child, parent)
    unless current_transformer.parent_variable_name_in_context.pluralize == current_transformer.parent_table_name

      # find the database migration that defines this relationship.
      migration_file_name = `grep "create_table :#{class_names_transformer.table_name} do |t|" db/migrate/*`.split(":").first
      unless migration_file_name.present?
        raise "No migration file seems to exist for creating the table `#{class_names_transformer.table_name}`"
      end

      replace_in_file(migration_file_name, "foreign_key: true", "foreign_key: {to_table: '#{current_transformer.parent_table_name}'}")
      modified_migration = true
    end

    # TODO remove the class_name if not needed.
    scaffold_add_line_to_file("./app/models/scaffolding/absolutely_abstract/creative_concept.rb", "has_many :completely_concrete_tangible_things, class_name: 'Scaffolding::CompletelyConcrete::TangibleThing', dependent: :destroy, foreign_key: :absolutely_abstract_creative_concept_id", HAS_MANY_HOOK, prepend: true)

    if class_names_transformer.belongs_to_needs_class_definition?
      scaffold_replace_line_in_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", transform_string("belongs_to :absolutely_abstract_creative_concept, class_name: 'Scaffolding::AbsolutelyAbstract::CreativeConcept'\n"), transform_string("belongs_to :absolutely_abstract_creative_concept\n"))
    end

    # # add routes and nested routes.
    # if child.include?("::")
    #   puts "!! We can't add namespaced routes. Manual instructions will follow below!"
    # else
    #   scaffold_route(child, parent)
    # end

    # add user permissions.
    ability_line, admin_ability_line = build_ability_line
    if admin_ability_line
      add_line_to_file("./app/models/ability.rb", ability_line, "# the following admin abilities were added by super scaffolding.")
    else
      add_line_to_file("./app/models/ability.rb", ability_line, "# the following abilities were added by super scaffolding.")
    end

    scaffold_replace_line_in_file("./test/controllers/account/scaffolding/completely_concrete/tangible_things_controller_test.rb", build_factory_setup.join("\n"), "# 🚅 super scaffolding will insert factory setup in place of this line.")
    # scaffold_replace_line_in_file("./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things_controller_test.rb", build_factory_setup.join("\n"), "# 🚅 super scaffolding will insert factory setup in place of this line.")

    # add children to the show page of their parent.
    unless parent == "None"
      scaffold_add_line_to_file("./app/views/account/scaffolding/absolutely_abstract/creative_concepts/show.html.erb", "<%= render 'account/scaffolding/completely_concrete/tangible_things/index', tangible_things: @creative_concept.completely_concrete_tangible_things#{".in_sort_order" if options["sortable"]}, hide_back: true %>", "<%# 🚅 super scaffolding will insert new children above this line. %>", prepend: true)
    end

    before_scaffolding_hooks = <<~RUBY
      # 🚅 add concerns above.
    RUBY

    after_scaffolding_hooks = <<-RUBY
  #{BELONGS_TO_HOOK}

  #{HAS_MANY_HOOK}

  #{HAS_ONE_HOOK}

  #{SCOPES_HOOK}

  #{VALIDATIONS_HOOK}

  #{CALLBACKS_HOOK}

  # 🚅 add delegations above.

  #{METHODS_HOOK}
    RUBY

    # add scaffolding hooks to the model.
    unless File.readlines(transform_string("./app/models/scaffolding/completely_concrete/tangible_thing.rb")).join.include?(CONCERNS_HOOK)
      scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", before_scaffolding_hooks, "ApplicationRecord", increase_indent: true)
    end
    unless File.readlines(transform_string("./app/models/scaffolding/completely_concrete/tangible_thing.rb")).join.include?(BELONGS_TO_HOOK)
      scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", after_scaffolding_hooks, "end", prepend: true, exact_match: true)
    end

    add_attributes_to_various_views(attributes, type: :crud)
    add_locale_helper_export_fix

    # add sortability.
    if options["sortable"]
      scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "def collection\n    absolutely_abstract_creative_concept.completely_concrete_tangible_things\n  end\n", METHODS_HOOK, prepend: true)
      scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_thing.rb", "include Sprinkles::Sortable\n", CONCERNS_HOOK, prepend: true)
      scaffold_replace_line_in_file("./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb", transform_string("<tbody data-reorder=\"<%= url_for [:reorder, :account, context, collection] %>\">"), "<tbody>")
      scaffold_add_line_to_file("./app/controllers/account/scaffolding/completely_concrete/tangible_things_controller.rb", "include Sprinkles::SortableActions\n", "Account::ApplicationController", increase_indent: true)
    end

    # titleize the localization file.
    replace_in_file(transform_string("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml"), child, child.underscore.humanize.titleize)

    # fix factories.
    # scaffold_replace_line_in_file("./test/factories/scaffolding/completely_concrete/tangible_things.rb", transform_string("association :team"), transform_string("team nil"))

    # apply routes.
    routes_manipulator = Scaffolding::RoutesFileManipulator.new("config/routes.rb", child, parent)
    begin
      routes_manipulator.apply(["account"])
    rescue
      add_additional_step :yellow, "We weren't able to automatically add your `account` routes for you. In theory this should be very rare, so if you could reach out on Slack, you could probably provide context that will help us fix whatever the problem was. In the meantime, to add the routes manually, we've got a guide at https://blog.bullettrain.co/nested-namespaced-rails-routing-examples/ ."
    end

    begin
      # routes_manipulator.apply(['api', 'v1'])
    rescue
      add_additional_step :yellow, "We weren't able to automatically add your `api/v1` routes for you. In theory this should be rare, (unless you're adding a resource under another resource that specifically don't have API routes,) so if you could reach out on Slack, you could probably provide context that will help us fix whatever the problem was. In the meantime, to add the routes manually, we've got a guide at https://blog.bullettrain.co/nested-namespaced-rails-routing-examples/ ."
    end

    routes_manipulator.write

    if parent == "Team" || parent == "None"
      icon_name = nil
      if options["sidebar"].present?
        icon_name = options["sidebar"]
      else
        puts ""
        puts "Hey, models that are scoped directly off of a Team (or nothing) are eligible to be added to the sidebar. Do you want to add this resource to the sidebar menu? (y/N)"
        response = STDIN.gets.chomp
        if response.downcase[0] == "y"
          puts ""
          puts "OK, great! Let's do this! By default these menu items appear with a puzzle piece, but after you hit enter I'll open two different pages where you can view other icon options. When you find one you like, hover your mouse over it and then come back here and and enter the name of the icon you want to use. (Or hit enter to skip this step.)"
          response = STDIN.gets.chomp
          `open https://themify.me/themify-icons`
          `open https://fontawesome.com/icons?d=gallery&s=light`
          puts ""
          puts "Did you find an icon you wanted to use? Enter the name here or hit enter to just use the puzzle piece:"
          icon_name = STDIN.gets.chomp
          puts ""
          unless icon_name.length > 0 || icon_name.downcase == "y"
            icon_name = "fal fa-puzzle-piece"
          end
        end
      end
      if icon_name.present?
        replace_in_file(transform_string("./config/locales/en/scaffolding/completely_concrete/tangible_things.en.yml"), "fal fa-puzzle-piece", icon_name)
        scaffold_add_line_to_file("./app/views/account/shared/_menu.html.erb", "<%= render 'account/scaffolding/completely_concrete/tangible_things/menu_item' %>", "<% # added by super scaffolding. %>")
      end
    end

    restart_server

    # if namespace_of(child)
    #   puts ""
    #   puts "NEXT STEPS"
    #   puts ""
    #   puts "1. We haven't worked out how to add namespaced routes to 'routes.rb' yet, so you'll"
    #   puts "   have to do that step yourself. To add a route for the account section, the end"
    #   puts "   result should function the same as this:"
    #   puts ""
    #   if namespace_of(child) == namespace_of(parent)
    #     puts "   namespace :#{namespace_of(parent).underscore} do"
    #     puts "     resources :#{class_name_of(parent).underscore.pluralize} do"
    #     puts "       resources :#{class_name_of(child).underscore.pluralize}"
    #     puts "     end"
    #     puts "   end"
    #     puts ""
    #     puts "   To add a route for the API, the end result should function the same as this:"
    #     puts ""
    #     puts "   namespace :#{namespace_of(parent).underscore} do"
    #     puts "     resources :#{class_name_of(parent).underscore.pluralize}, only: api_actions do"
    #     puts "       resources :#{child.split('::').last.underscore.pluralize}, only: api_actions"
    #     puts "     end"
    #     puts "   end"
    #   elsif namespace_of(child) && namespace_of(parent)
    #     puts "   namespace :#{namespace_of(parent).underscore} do"
    #     puts "     resources :#{class_name_of(parent).underscore.pluralize} do"
    #     puts "       namespace :#{namespace_of(child).underscore} do"
    #     puts "         resources :#{class_name_of(child).underscore.pluralize}"
    #     puts "       end"
    #     puts "     end"
    #     puts "   end"
    #     puts ""
    #     puts "   To add a route for the API, the end result should function the same as this:"
    #     puts ""
    #     puts "   namespace :#{namespace_of(parent).underscore} do"
    #     puts "     resources :#{class_name_of(parent).underscore.pluralize}, only: api_actions do"
    #     puts "       namespace :#{namespace_of(child).underscore} do"
    #     puts "         resources :#{class_name_of(child).underscore.pluralize}, only: api_actions"
    #     puts "       end"
    #     puts "     end"
    #     puts "   end"
    #   elsif parent == 'Team'
    #     puts "   resources :teams do"
    #     puts "     shallow do"
    #     puts "       namespace :#{namespace_of(child).underscore} do"
    #     puts "         resources :#{class_name_of(child).underscore.pluralize}"
    #     puts "       end"
    #     puts "     end"
    #     puts "   end"
    #     puts ""
    #     puts "   To add a route for the API, the end result should function the same as this:"
    #     puts ""
    #     puts "   resources :teams do"
    #     puts "     shallow do"
    #     puts "       namespace :#{namespace_of(child).underscore} do"
    #     puts "         resources :#{class_name_of(child).underscore.pluralize}, only: api_actions"
    #     puts "       end"
    #     puts "     end"
    #     puts "   end"
    #   else
    #     puts "   resources :teams do"
    #     puts "     namespace :#{namespace_of(child).underscore} do"
    #     puts "       resources :#{class_name_of(child).underscore.pluralize}"
    #     puts "     end"
    #     puts "   end"
    #     puts ""
    #     puts "   To add a route for the API, the end result should function the same as this:"
    #     puts ""
    #     puts "   resources :teams do"
    #     puts "     namespace :#{namespace_of(child).underscore} do"
    #     puts "       resources :#{class_name_of(child).underscore.pluralize}, only: api_actions"
    #     puts "     end"
    #     puts "   end"
    #   end
    # end
  end
end
