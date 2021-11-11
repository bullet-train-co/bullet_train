require_relative "../../lib/theme_partials"

module ThemeHelper
  include ThemePartials

  def current_theme
    THEME_DIRECTORY_ORDER.first
  end

  def render(options = {}, locals = {}, &block)
    if options.is_a?(String)
      theme_partial = Resolver.resolve(options)

      return super theme_partial, locals, &block unless theme_partial.blank?
    end

    super
  end
end
