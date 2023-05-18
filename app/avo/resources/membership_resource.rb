class MembershipResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :name, as: :text, hide_on: :forms
  field :user_profile_photo_id, as: :text
  field :user_email, as: :text
  field :added_by_id, as: :number
  field :role_ids, as: :tags
  field :user, as: :belongs_to
  field :team, as: :belongs_to
  field :invitation, as: :belongs_to
  field :added_by, as: :belongs_to
end
