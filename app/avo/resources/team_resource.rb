class TeamResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :name, as: :text
  field :slug, as: :text
  field :being_destroyed, as: :boolean
  field :time_zone, as: :text
  field :locale, as: :text
  field :memberships, as: :has_many
  field :users, as: :has_many, through: :memberships
  field :invitations, as: :has_many
  field :platform_applications, as: :has_many
  field :webhooks_outgoing_endpoints, as: :has_many
  field :webhooks_outgoing_events, as: :has_many
  # add fields here
end
