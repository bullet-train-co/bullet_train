class InvitationResource < Avo::BaseResource
  self.title = :email
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :email, as: :text
  field :uuid, as: :text
  field :team, as: :belongs_to
  field :from_membership, as: :belongs_to
  field :membership, as: :has_one
end
