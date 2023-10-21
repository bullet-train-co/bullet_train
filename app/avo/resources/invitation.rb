class Avo::Resources::Invitation < Avo::BaseResource
  self.title = :email
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], email_cont: params[:q], m: "or").result(distinct: false) },
  #   item: -> {
  #     {
  #       title: record.email
  #     }
  #   }
  # }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :team, as: :belongs_to
    field :from_membership, as: :belongs_to
    field :membership, as: :has_one
    field :uuid, as: :text
  end
end
