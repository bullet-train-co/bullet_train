module Fields::SuperSelectSupport
  extend ActiveSupport::Concern

  def create_model_if_new(id)
    if id.present?
      unless /^\d+$/.match?(id)
        id = yield(id).id.to_s
      end
    end
    id
  end

  def create_models_if_new(ids)
    ids.map do |id|
      create_model_if_new(id) do
        yield(id)
      end
    end
  end
end
