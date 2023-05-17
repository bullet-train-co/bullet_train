class UserResource < Avo::BaseResource
  self.title = :id
  self.includes = []

  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  field :email, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :time_zone, as: :text

  field :teams, as: :has_many, through: :teams
  field :memberships, as: :has_many
end
