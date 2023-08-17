class Avo::Resources::Membership < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search = {
    query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], user_email_cont: params[:q], role_cont: params[:q], m: "or").result(distinct: false) },
    item: -> {
      {
        title: record.name,
        description: "Membership of #{team.name}"
      }
    }
  }

  def fields
    field :id, as: :id
    field :name, as: :text, hide_on: :forms
    field :user_profile_photo_id, as: :text
    field :user_email, as: :text
    field :added_by_id, as: :number
    field :role_ids, as: :tags
    field :user, as: :belongs_to, searchable: true
    field :team, as: :belongs_to, searchable: true
    field :invitation, as: :belongs_to, searchable: true
    field :added_by, as: :belongs_to, searchable: true
  end
end
