class Scaffolding::RoutesFileManipulator
  attr_accessor :child, :parent, :lines, :transformer_options

  def initialize(filename, child, parent, transformer_options = {})
    self.child = child
    self.parent = parent
    @filename = filename
    self.lines = File.readlines(@filename)
    self.transformer_options = transformer_options
  end

  def child_parts
    @child_parts ||= child.underscore.pluralize.split("/")
  end

  def parent_parts
    @parent_parts ||= parent.underscore.pluralize.split("/")
  end

  def common_namespaces
    unless @common_namespaces
      @common_namespaces ||= []
      child_parts_copy = child_parts.dup
      parent_parts_copy = parent_parts.dup
      while child_parts_copy.first == parent_parts_copy.first && child_parts_copy.count > 1 && parent_parts_copy.count > 1
        @common_namespaces << child_parts_copy.shift
        parent_parts_copy.shift
      end
    end
    @common_namespaces
  end

  # def divergent_namespaces
  #   unless @divergent_namespaces
  #     @divergent_namespaces ||= []
  #     child_parts_copy = child_parts.dup
  #     parent_parts_copy = parent_parts.dup
  #     while child_parts_copy.first == parent_parts_copy.first
  #       child_parts_copy.shift
  #       parent_parts_copy.shift
  #     end
  #     child_parts_copy.pop
  #     parent_parts_copy.pop
  #     @divergent_namespaces = [child_parts_copy, parent_parts_copy]
  #   end
  #   @divergent_namespaces
  # end

  def divergent_parts
    unless @divergent_namespaces
      @divergent_namespaces ||= []
      child_parts_copy = child_parts.dup
      parent_parts_copy = parent_parts.dup
      while child_parts_copy.first == parent_parts_copy.first && child_parts_copy.count > 1 && parent_parts_copy.count > 1
        child_parts_copy.shift
        parent_parts_copy.shift
      end
      child_resource = child_parts_copy.pop
      parent_resource = parent_parts_copy.pop
      @divergent_namespaces = [child_parts_copy, child_resource, parent_parts_copy, parent_resource]
    end
    @divergent_namespaces
  end

  def find_namespaces(namespaces, within = nil)
    namespaces = namespaces.dup
    results = {}
    block_end = find_block_end(within) if within
    lines.each_with_index do |line, line_number|
      if within
        next unless line_number > within
        return results if line_number >= block_end
      end
      if line.include?("namespace :#{namespaces.first} do")
        results[namespaces.shift] = line_number
      end
      return results unless namespaces.any?
    end
    results
  end

  def indentation_of(line_number)
    lines[line_number].match(/^( +)/)[1]
  rescue
    nil
  end

  def find_block_parent(starting_line_number)
    return nil unless indentation_of(starting_line_number)
    cursor = starting_line_number
    while cursor >= 0
      unless lines[cursor].match?(/^#{indentation_of(starting_line_number)}/) || !lines[cursor].present?
        return cursor
      end
      cursor -= 1
    end
    nil
  end

  def find_block_end(starting_line_number)
    return nil unless indentation_of(starting_line_number)
    lines.each_with_index do |line, line_number|
      next unless line_number > starting_line_number
      if /^#{indentation_of(starting_line_number)}end\s+/.match?(line)
        return line_number
      end
    end
    nil
  end

  def insert_before(new_lines, line_number, options = {})
    options[:indent] ||= false
    before = lines[0..(line_number - 1)]
    new_lines = new_lines.map { |line| (indentation_of(line_number) + (options[:indent] ? "  " : "") + line).gsub(/\s+$/, "") + "\n" }
    after = lines[line_number..]
    self.lines = before + (options[:prepend_newline] ? ["\n"] : []) + new_lines + after
  end

  def insert_after(new_lines, line_number, options = {})
    options[:indent] ||= false
    before = lines[0..line_number]
    new_lines = new_lines.map { |line| (indentation_of(line_number) + (options[:indent] ? "  " : "") + line).gsub(/\s+$/, "") + "\n" }
    after = lines[(line_number + 1)..]
    self.lines = before + new_lines + (options[:append_newline] ? ["\n"] : []) + after
  end

  def insert_in_namespace(namespaces, new_lines, within = nil)
    namespace_lines = find_namespaces(namespaces, within)
    if namespace_lines[namespaces.last]
      block_start = namespace_lines[namespaces.last]
      insertion_point = find_block_end(block_start)
      insert_before(new_lines, insertion_point, indent: true, prepend_newline: (insertion_point > block_start + 1))
    else
      raise "we weren't able to insert the following lines into the namespace block for #{namespaces.join(" -> ")}:\n\n#{new_lines.join("\n")}"
    end
  end

  def find_or_create_namespaces(namespaces, within = nil)
    namespaces = namespaces.dup
    created_namespaces = []
    current_namespace = nil
    while namespaces.any?
      current_namespace = namespaces.shift
      namespace_lines = find_namespaces(created_namespaces + [current_namespace], within)
      unless namespace_lines[current_namespace]
        lines_to_add = ["namespace :#{current_namespace} do", "end"]
        if created_namespaces.any?
          insert_in_namespace(created_namespaces, lines_to_add, within)
        else
          insert(lines_to_add, within)
        end
      end
      created_namespaces << current_namespace
    end
    namespace_lines = find_namespaces(created_namespaces + [current_namespace], within)
    namespace_lines ? namespace_lines[current_namespace] : nil
  end

  def find(needle, within = nil)
    lines_within(within).each_with_index do |line, line_number|
      return (within + (within ? 1 : 0) + line_number) if line.match?(needle)
    end

    nil
  end

  def find_in_namespace(needle, namespaces, within = nil, ignore = nil)
    if namespaces.any?
      namespace_lines = find_namespaces(namespaces, within)
      within = namespace_lines[namespaces.last]
    end

    lines_within(within).each_with_index do |line, line_number|
      # + 2 because line_number starts from 0, and within starts one line after
      actual_line_number = (within + line_number + 2)

      # The lines we want to ignore may be a a series of blocks, so we check each Range here.
      ignore_line = false
      if ignore.present?
        ignore.each do |lines_to_ignore|
          ignore_line = true if lines_to_ignore.include?(actual_line_number)
        end
      end

      next if ignore_line
      return (within + (within ? 1 : 0) + line_number) if line.match?(needle)
    end

    nil
  end

  def find_resource_block(parts, options = {})
    within = options[:within]
    parts = parts.dup
    resource = parts.pop
    # TODO this doesn't take into account any options like we do in `find_resource`.
    find_in_namespace(/resources :#{resource}#{options[:options] ? ", #{options[:options].gsub(/(\[)(.*)(\])/, '\[\2\]')}" : ""}(,?\s.*)? do(\s.*)?$/, parts, within)
  end

  def find_resource(parts, options = {})
    parts = parts.dup
    resource = parts.pop
    needle = /resources :#{resource}#{options[:options] ? ", #{options[:options].gsub(/(\[)(.*)(\])/, '\[\2\]')}" : ""}(,?\s.*)?$/
    find_in_namespace(needle, parts, options[:within], options[:ignore])
  end

  def find_or_create_resource(parts, options = {})
    parts = parts.dup
    resource = parts.pop
    namespaces = parts
    namespace_within = find_or_create_namespaces(namespaces, options[:within])

    # The namespaces that the developer has declared are captured above in `namespace_within`,
    # so all other namespaces nested inside the resource's parent should be ignored.
    options[:ignore] = top_level_namespace_block_lines(options[:within]) || []

    unless (result = find_resource([resource], options))
      result = insert(["resources :#{resource}" + (options[:options] ? ", #{options[:options]}" : "")], namespace_within || options[:within])
    end
    result
  end

  def top_level_namespace_block_lines(within)
    local_namespace_blocks = []
    lines_within(within).each do |line|
      # i.e. - Retrieve "foo" from "namespace :foo do"
      match_data = line.match(/(\s*namespace\s:)(.*)(\sdo$)/)

      # Since we only want top-level namespace blocks, we ensure that
      # all other namespace blocks INSIDE the top-level namespace blocks are skipped
      if match_data.present?
        namespace_name = match_data[2]
        local_namespace = find_namespaces([namespace_name], within)
        starting_line_number = local_namespace[namespace_name]
        local_namespace_block = ((starting_line_number + 1)..(find_block_end(starting_line_number) + 1))

        if local_namespace_blocks.empty?
          local_namespace_blocks << local_namespace_block
        else
          skip_block = false
          local_namespace_blocks.each do |block_range|
            if block_range.include?(local_namespace_block.first)
              skip_block = true
            else
              next
            end
          end
          local_namespace_blocks << local_namespace_block unless skip_block
        end
      end
    end

    local_namespace_blocks
  end

  def find_or_create_resource_block(parts, options = {})
    find_or_create_resource(parts, options)
    find_or_convert_resource_block(parts.last, options)
  end

  def lines_within(within)
    return lines unless within
    lines[(within + 1)..(find_block_end(within) + 1)]
  end

  def find_or_convert_resource_block(parent_resource, options = {})
    unless find_resource_block([parent_resource], options)
      if (resource_line_number = find_resource([parent_resource], options))
        # convert it.
        lines[resource_line_number].gsub!("\n", " do\n")
        insert_after(["end"], resource_line_number)
      else
        raise "the parent resource (`#{parent_resource}`) doesn't appear to exist in `#{@filename}`."
      end
    end

    # update the block of code we're working within.
    unless (within = find_resource_block([parent_resource], options))
      raise "tried to convert the parent resource to a block, but failed?"
    end

    within
  end

  def insert(lines_to_add, within)
    insertion_line = find_block_end(within)
    result_line = insertion_line
    unless insertion_line == within + 1
      # only put the extra space if we're adding this line after a block
      if /^\s*end\s*$/.match?(lines[insertion_line - 1])
        lines_to_add.unshift("")
        result_line += 1
      end
    end
    insert_before(lines_to_add, insertion_line, indent: true)
    result_line
  end

  def apply(base_namespaces)
    child_namespaces, child_resource, parent_namespaces, parent_resource = divergent_parts

    within = find_or_create_namespaces(base_namespaces)
    within = find_or_create_namespaces(common_namespaces, within) if common_namespaces.any?

    # e.g. Project and Projects::Deliverable
    if parent_namespaces.empty? && child_namespaces.one? && parent_resource == child_namespaces.first

      # resources :projects do
      #   scope module: 'projects' do
      #     resources :deliverables, only: collection_actions
      #   end
      # end

      parent_within = find_or_convert_resource_block(parent_resource, within: within)

      # add the new resource within that namespace.
      line = "scope module: '#{parent_resource}' do"
      # TODO you haven't tested this yet.
      unless (scope_within = find(/#{line}/, parent_within))
        scope_within = insert([line, "end"], parent_within)
      end

      find_or_create_resource([child_resource], options: "only: collection_actions", within: scope_within)

      # namespace :projects do
      #   resources :deliverables, except: collection_actions
      # end

      unless find_namespaces(child_namespaces, within)[child_namespaces.last]
        insert_after(["", "namespace :#{child_namespaces.last} do", "end"], find_block_end(scope_within))
        unless find_namespaces(child_namespaces, within)[child_namespaces.last]
          raise "tried to insert `namespace :#{child_namespaces.last}` but it seems we failed"
        end
      end

      find_or_create_resource(child_namespaces + [child_resource], options: "except: collection_actions", within: within)

    # e.g. Projects::Deliverable and Objective Under It, Abstract::Concept and Concrete::Thing
    elsif parent_namespaces.any?

      # namespace :projects do
      #   resources :deliverables
      # end
      #
      # resources :projects_deliverables, path: 'projects/deliverables' do
      #   resources :objectives
      # end

      find_resource(parent_namespaces + [parent_resource], within: within)
      top_parent_namespace = find_namespaces(parent_namespaces, within)[parent_namespaces.first]
      block_parent_within = find_block_parent(top_parent_namespace)
      parent_namespaces_and_resource = (parent_namespaces + [parent_resource]).join("_")
      parent_within = find_or_create_resource_block([parent_namespaces_and_resource], options: "path: '#{parent_namespaces_and_resource.tr("_", "/")}'", within: block_parent_within)
      find_or_create_resource(child_namespaces + [child_resource], within: parent_within)

    else

      begin
        within = find_or_convert_resource_block(parent_resource, within: within)
      rescue
        within = find_or_convert_resource_block(parent_resource, options: "except: collection_actions", within: within)
      end

      find_or_create_resource(child_namespaces + [child_resource], options: define_concerns, within: within)

    end
  end

  # Pushing custom concerns here will add them to the routes file when Super Scaffolding.
  def define_concerns
    concerns = []
    concerns.push(:sortable) if transformer_options["sortable"]

    return if concerns.empty?
    "concerns: #{concerns}"
  end

  def write
    puts "Updating '#{@filename}'."
    File.open(@filename, "w+") do |file|
      file.puts(lines.join.strip + "\n")
    end
  end
end
