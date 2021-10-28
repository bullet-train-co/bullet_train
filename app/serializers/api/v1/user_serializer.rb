class Api::V1::UserSerializer < Api::V1::ApplicationSerializer
  set_type "user"

  attributes :id,
    :email,
    :first_name,
    :last_name,
    :time_zone,
    :profile_photo_id,
    :former_user,
    :locale,
    :platform_agent_of_id,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  has_many :teams, serializer: Api::V1::TeamSerializer
  has_many :memberships, serializer: Api::V1::MembershipSerializer
end
