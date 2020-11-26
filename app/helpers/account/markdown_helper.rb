module Account::MarkdownHelper
  def markdown(string)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})
    @markdown.render(string).html_safe
  end
end
