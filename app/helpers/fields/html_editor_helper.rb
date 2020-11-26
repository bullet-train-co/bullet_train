module Fields::HtmlEditorHelper
  TEMPORARY_REPLACEMENT = "https://temp.bullettrain.co/"
  def html_sanitize(string)
    return string unless string
    string = sanitize(string, tags: %w(div br strong em b i del a h1 blockquote pre ul ol li), attributes: %w(href))
    links_target_blank(string).html_safe
  end

  def links_target_blank(body)
    doc = Nokogiri::HTML(body)
    doc.css('a').each do |link|
      link['target'] = '_blank'
      # To avoid window.opener attack when target blank is used
      # https://mathiasbynens.github.io/rel-noopener/
      link['rel'] = 'noopener'
    end
    doc.to_s
  end
end
