class Avo::Resources::Page < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }
  
  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :path, as: :textarea
  end
end
