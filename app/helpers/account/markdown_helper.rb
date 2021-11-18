module Account::MarkdownHelper
  def markdown(string)
    CommonMarker.render_html(string, :UNSAFE, [:table]).html_safe
  end
end
