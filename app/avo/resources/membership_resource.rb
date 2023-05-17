class MembershipResource < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :user_id, as: :number
  field :team_id, as: :number
  field :invitation_id, as: :number
  field :user_first_name, as: :text
  field :user_last_name, as: :text
  field :user_profile_photo_id, as: :text
  field :user_email, as: :text
  field :added_by_id, as: :number
  field :platform_agent_of_id, as: :number
  field :role_ids, as: :text
  field :platform_agent, as: :boolean
  field :webhooks_outgoing_events, as: :has_many
  field :user, as: :belongs_to
  field :team, as: :belongs_to
  field :invitation, as: :belongs_to
  field :added_by, as: :belongs_to
  field :platform_agent_of, as: :belongs_to
  # add fields here
end
