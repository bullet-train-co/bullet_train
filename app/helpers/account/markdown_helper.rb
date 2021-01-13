module Account::MarkdownHelper
  def markdown(string)
    CommonMarker.render_html(string, :UNSAFE).html_safe
  end
end
