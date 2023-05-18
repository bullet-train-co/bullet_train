class TeamResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = -> do
    scope.ransack(id_eq: params[:q], name_cont: params[:q], m: "or").result(distinct: false)
  end

  field :id, as: :id
  field :name, as: :text
  field :slug, as: :text
  field :being_destroyed, as: :boolean, hide_on: :forms
  field :time_zone, as: :text
  field :locale, as: :text
  field :users, as: :has_many, through: :memberships
  field :memberships, as: :has_many
  field :invitations, as: :has_many
end
