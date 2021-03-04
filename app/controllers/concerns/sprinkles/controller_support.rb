module Sprinkles::ControllerSupport
  extend ActiveSupport::Concern

  included do
    after_action :add_request_metadata
  end

  def add_request_metadata
    response.headers['X-Sprinkles-Request-URL'] = remove_layoutless_from_url(request.url)
    response.headers['X-Sprinkles-Request-Method'] = request.method
  end

  def remove_layoutless_from_url(url)
    if url.is_a?(Array)
      if url.last.is_a?(Hash)
        url.delete(:layoutless)
      end
    else
      uri = URI.parse(url)
      query = Rack::Utils.parse_query(uri.query)
      query.delete('layoutless')
      uri.query = query.to_query
      uri.query = nil if uri.query.empty?
      url = uri.to_s
    end
    url
  end

  def make_url_layoutless(url)
    if url.is_a?(Array)
      if url.last.is_a?(Hash)
        url.last[:layoutless] = true
      else
        url << {layoutless: true}
      end
    else
      uri = URI.parse(url)
      query = Rack::Utils.parse_query(uri.query)
      query[:layoutless] = true
      uri.query = query.to_query
      url = uri.to_s
    end
    url
  end

  # TODO Why is `url` optional? I'm just copying this from Turbolinks.
  def redirect_to(url = {}, options = {})
    # If we're redirecting from a request where we were asked to respond "layoutless" ..
    if params[:layoutless] == 'true'
      # Make sure the URL we're redirecting to is "layoutless".
      url = make_url_layoutless(url)

      # Disable Turbolinks from sending it's own headers. (We love you Turbolinks ❤️, but we've got this! 💪)
      # Not sure what this will be under hotwire/turbo
      options[:turbolinks] = false
    end

    super
  end
end
