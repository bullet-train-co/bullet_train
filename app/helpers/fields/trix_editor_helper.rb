module Fields::TrixEditorHelper
  TEMPORARY_REPLACEMENT = "https://temp.bullettrain.co/"
  def trix_sanitize(string)
    return string unless string
    # TODO this is a hack to get around the fact that rails doesn't allow us to add any acceptable protocols.
    string = string.gsub('bullettrain://', TEMPORARY_REPLACEMENT)
    string = sanitize(string, tags: %w(div br strong em del a h1 blockquote pre ul ol li), attributes: %w(href))
    # given the limited scope of what we're doing here, this string replace should work.
    # it should also use a lot less memory than nokogiri.
    string = string.gsub(/<a href="#{TEMPORARY_REPLACEMENT}(.*?)\/.*?">(.*?)<\/a>/, "<span class=\"tribute-reference tribute-\\1-reference\">\\2</span>").html_safe
    trix_content(string)
  end

  def trix_content(body)
    links_target_blank(body).html_safe
  end
end
