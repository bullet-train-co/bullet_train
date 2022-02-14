class Api::V1::MembershipSerializer < Api::V1::ApplicationSerializer
  include Api::V1::Memberships::SerializerBase

  # The `:id` entries are redundant, but for the moment they help us generate valid code.
  attributes :id,
    # 🚅 super scaffolding will insert new fields above this line.
    :id
end
