# TODO: Remove this monkey patch initializer when the following issue has been resolved in rails core:
# https://github.com/rails/rails/issues/52233

require "action_text/content"

module ActionText
  class Content
    def render_attachments(**options, &block)
      content = fragment.replace(ActionText::Attachment.tag_name) do |node|
        if node.key?("content") && node["content"].present?
          node["content"] = sanitize_content_attachment(node["content"])
        elsif node.key?("content")
          node.remove_attribute("content")
        end
        block.call(attachment_for_node(node, **options))
      end
      self.class.new(content, canonicalize: false)
    end
  end
end
