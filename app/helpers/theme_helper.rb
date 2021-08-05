module ThemeHelper
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

  # This global variable is created once per application boot.
  # We're not using the Rails caching system because we want everything in local memory for this.
  # If we use the Rails caching system, we end up querying it over the wire from Redis or memcached.
  $resolved_theme_partials = {}

  def current_theme
    THEME_DIRECTORY_ORDER.first
  end

  def render(options = {}, locals = {}, &block)
    if options.is_a?(String)
      INCLUDE_TARGETS.each do |include_target|
        if options.start_with? include_target
          # If the partial path has already been resolved since boot, just return that value.
          # This caching is not enabled in development so people can introduce new files without restarting.
          unless Rails.env.development?
            if $resolved_theme_partials[options]
              return super $resolved_theme_partials[options], locals, &block
            end
          end

          # Otherwise, we need to traverse the inheritance structure of the themes to find the right partial.
          normal_file_path = options.sub(/.*\K\//, "/_")
          debased_file_path = normal_file_path.sub("#{include_target}/", "")
          # TODO this is a hack because the main menu is still in this directory
          # and other people might also add stuff there.
          unless File.exist?("#{Rails.root}/app/views/#{normal_file_path}.html.erb")
            THEME_DIRECTORY_ORDER.each do |theme_directory|
              if File.exist?("#{Rails.root}/app/views/themes/#{theme_directory}/#{debased_file_path}.html.erb")
                # Once we've found it, ensure we don't do this again for the same partial.
                $resolved_theme_partials[options] = "themes/#{theme_directory}/#{debased_file_path}".gsub("/_", "/")
                return super $resolved_theme_partials[options], locals, &block
              end
            end
          end
        end
      end
    end

    super
  end
end
