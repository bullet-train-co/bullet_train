# We have to do this because there are a couple of different Grape contexts where you're trying to define something
# for a model's API representation, but the execution context doesn't have access to the endpoint object you're
# defining things for. I understand the design thinking that caused that situation, but unfortunately for us we just
# have to brute force our way around it for now. In doing so, we're implementing something not unlike the magic of the
# `t` helper in Rails views.

def api_topic
  path = caller.find { |path| path.include?("controllers/api") }
  path.gsub!(/^#{Rails.root}\/app\/controllers\/api\/v\d+\//, "")
  path.split("_endpoint.").first
end

def gt(path)
  I18n.t("#{api_topic}.api.#{path}")
end

def gth(path)
  I18n.t("#{api_topic}.api.fields.#{path}.heading")
end
