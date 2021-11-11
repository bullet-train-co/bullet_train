module ThemePartials
  THEME_DIRECTORY_ORDER = [
    "light",
    "tailwind",
    "base",
  ]

  INCLUDE_TARGETS = [
    # ❌ This path is included for legacy purposes, but you shouldn't reference partials like this in new code.
    "account/shared",

    # ✅ This is the correct path to generically reference theme component partials with.
    "shared"
  ]

  # i.e. Changes "account/shared/box" to "account/shared/_box"
  def convert_to_literal_partial(path)
    path.sub(/.*\K\//, "/_")
  end

  # i.e. Changes "account/shared/_box" to "_box"
  def remove_hierarchy_base(path, include_target)
    path.sub(/^#{include_target}\//, "")
  end

  # i.e. Get "app/views/themes/light/_box.html.erb" from "_box"
  def get_full_debased_file_path(path, theme_directory)
    "app/views/themes/#{theme_directory}/#{path}.html.erb"
  end

  # Adds a hierarchy with a specific theme to a partial.
  # i.e. Changes "workflow/box" to "themes/light/workflow/box"
  def add_hierarchy_to_path(file_path, theme_directory)
    "themes/#{theme_directory}/#{file_path}"
  end

  class Resolver
    extend ThemePartials

    # This global variable is created once per application boot.
    # We're not using the Rails caching system because we want everything in local memory for this.
    # If we use the Rails caching system, we end up querying it over the wire from Redis or memcached.
    $resolved_theme_partials = {}

    def self.resolve(options)
      INCLUDE_TARGETS
        .filter { |include_target| options.start_with? include_target }
        .each do |include_target|
        # If the partial path has already been resolved since boot, just return that value.
        # This caching is not enabled in development so people can introduce new files without restarting.
        unless Rails.env.development?
          if $resolved_theme_partials[options]
            return $resolved_theme_partials[options]
          end
        end

        # Otherwise, we need to traverse the inheritance structure of the themes to find the right partial.
        debased_file_path = remove_hierarchy_base(options, include_target)
        normal_file_path = convert_to_literal_partial(options)

        # TODO this is a hack because the main menu is still in this directory
        # and other people might also add stuff there.
        unless File.exist?("#{Rails.root}/app/views/#{normal_file_path}.html.erb")
          THEME_DIRECTORY_ORDER.each do |theme_directory|
            full_debased_file_path = convert_to_literal_partial(get_full_debased_file_path(debased_file_path, theme_directory))
            if File.exist?(full_debased_file_path)
              # Once we've found it, ensure we don't do this again for the same partial.
              $resolved_theme_partials[options] = add_hierarchy_to_path(debased_file_path, theme_directory)
              return $resolved_theme_partials[options]
            end
          end
        end
      end

      nil
    end
  end
end
