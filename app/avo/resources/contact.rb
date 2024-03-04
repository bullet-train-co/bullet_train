class Avo::Resources::Contact < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :client, as: :belongs_to
    field :first_name, as: :text
    field :last_name, as: :text
    field :email, as: :text
    field :notes, as: :textarea
  end
end
