class Avo::Resources::Membership < Avo::BaseResource
  self.title = :name
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], name_cont: params[:q], user_email_cont: params[:q], role_cont: params[:q], m: "or").result(distinct: false) },
  #   item: -> {
  #     {
  #       title: record.name,
  #     }
  #   }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text, hide_on: :forms
    field :user_email, as: :text
    field :role_ids, as: :tags, suggestions: -> { [:admin, :editor] }, enforce_suggestions: true
    field :user, as: :belongs_to
    field :team, as: :belongs_to
    field :invitation, as: :belongs_to
    field :added_by, as: :belongs_to
  end
end
