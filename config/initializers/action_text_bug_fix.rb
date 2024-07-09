# TODO: Remove this monkey patch initializer when the following issue has been resolved in rails core:
# https://github.com/rails/rails/issues/52233

require "action_text/content"

module ActionText
  class Content
    def render_attachments(**options, &block)
      content = fragment.replace(ActionText::Attachment.tag_name) do |node|
        if node.key?("content")
          sanitized_content = sanitize_content_attachment(node.remove_attribute("content").to_s)
          node["content"] = sanitized_content if sanitized_content.present?
        end
        block.call(attachment_for_node(node, **options))
      end
      self.class.new(content, canonicalize: false)
    end
  end
end
