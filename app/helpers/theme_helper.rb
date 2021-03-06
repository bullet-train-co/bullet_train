module ThemeHelper
  THEME_DIRECTORY_ORDER = [
    'light',
    'tailwind',
    'base',
  ]

  INCLUDE_TARGETS = [
    'account/shared',
    'shared'
  ]

  def current_theme
    'light'
  end

  def render(options={}, locals={}, &block)
    if options.is_a?(String)
      INCLUDE_TARGETS.each do |include_target|
        if options.start_with? include_target
          normal_file_path = options.sub(/.*\K\//, '/_')
          debased_file_path = normal_file_path.sub("#{include_target}/", '')
          # TODO this is a hack because the main menu is still in this directory
          # and other people might also add stuff there.
          unless File.exists?("#{Rails.root}/app/views/#{normal_file_path}.html.erb")
            THEME_DIRECTORY_ORDER.each do |theme_directory|
              if File.exists?("#{Rails.root}/app/views/themes/#{theme_directory}/#{debased_file_path}.html.erb")
                return super "themes/#{theme_directory}/#{debased_file_path}".gsub('/_', '/'), locals, &block
              end
            end
          end
        end
      end
    end

    super
  end
end
