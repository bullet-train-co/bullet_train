# We have to do this because there are a couple of different Grape contexts where you're trying to define something
# for a model's API representation, but the execution context doesn't have access to the endpoint object you're
# defining things for. I understand the design thinking that caused that situation, but unfortunately for us we just
# have to brute force our way around it for now. In doing so, we're implementing something not unlike the magic of the
# `t` helper in Rails views.

module Api
  def self.topic
    path = caller.find { |path| path.include?("controllers/api") && !path.include?("app/controllers/api.rb") }
    path.gsub!(/^#{Rails.root}\/app\/controllers\/api\/v\d+\//, "")
    path.split("_endpoint.").first
  end

  def self.serializer
    # TODO This could be smart enough to figure out if `V1` is accurate, as well.
    "Api::V1::#{Api.topic.classify}Serializer"
  end

  def self.status(code)
    I18n.t("api.statuses.#{code}")
  end

  def self.title(path)
    I18n.t("#{topic}.api.#{path}")
  end

  def self.heading(path)
    I18n.t("#{topic}.api.fields.#{path}.heading")
  end

  def self.show_desc
    proc do
      success code: 200, model: Api.serializer, message: Api.status(200)
      failure [
        {code: 401, message: Api.status(401)}, # unauthorized
        {code: 403, message: Api.status(403)}, # forbidden
        {code: 404, message: Api.status(404)}, # not found
        {code: 429, message: Api.status(429)} # too many requests
      ]
      produces ["application/vnd.api+json"]
    end
  end

  def self.index_desc
    proc do
      success code: 200, model: Api.serializer, message: Api.status(200)
      failure [
        {code: 401, message: Api.status(401)}, # unauthorized
        {code: 429, message: Api.status(429)} # too many requests
      ]
      produces ["application/vnd.api+json"]
      is_array true
    end
  end

  def self.create_desc
    proc do
      success code: 201, model: Api.serializer, message: Api.status(201)
      failure [
        {code: 400, message: Api.status(400)}, # bad request
        {code: 401, message: Api.status(401)}, # unauthorized
        {code: 403, message: Api.status(403)}, # forbidden
        {code: 406, message: Api.status(406)}, # not acceptable
        {code: 422, message: Api.status(422)}, # unprocessable entity
        {code: 429, message: Api.status(429)} # too many requests
      ]
      consumes ["application/json", "multipart/form-data"]
      produces ["application/vnd.api+json"]
    end
  end

  def self.update_desc
    proc do
      success code: 200, model: Api.serializer, message: Api.status(200)
      failure [
        {code: 400, message: Api.status(400)}, # bad request
        {code: 401, message: Api.status(401)}, # unauthorized
        {code: 403, message: Api.status(403)}, # forbidden
        {code: 404, message: Api.status(404)}, # not found
        {code: 406, message: Api.status(406)}, # not acceptable
        {code: 422, message: Api.status(422)}, # unprocessable entity
        {code: 429, message: Api.status(429)} # too many requests
      ]
      consumes ["application/json", "multipart/form-data"]
      produces ["application/vnd.api+json"]
    end
  end

  def self.destroy_desc
    # TODO We don't have anything for this, but we want to make sure it's easy to roll out updates going forward.
    proc {}
  end
end
