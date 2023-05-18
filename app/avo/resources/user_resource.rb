class UserResource < Avo::BaseResource
  self.title = :full_name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], first_name_cont: params[:q], last_name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :email, as: :text
  field :first_name, as: :text
  field :last_name, as: :text
  field :time_zone, as: :text
  field :current_team, as: :belongs_to

  field :teams, as: :has_many, through: :teams
  field :memberships, as: :has_many
end
