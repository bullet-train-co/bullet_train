class Api::V1::InvitationSerializer < Api::V1::ApplicationSerializer
  set_type "invitation"

  attributes :id,
    :team_id,
    :email,
    :from_membership_id,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :from_membership, serializer: Api::V1::MembershipSerializer
  has_one :membership, serializer: Api::V1::MembershipSerializer
end
