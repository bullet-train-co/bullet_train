class Avo::Resources::Invitation < Avo::BaseResource
  self.title = :email
  self.includes = []
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], email_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.title
      }
    }
  }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :uuid, as: :text
    field :team, as: :belongs_to, searchable: true
    field :from_membership, as: :belongs_to, searchable: true
    field :membership, as: :has_one
  end
end
