class Api::V1::Memberships::Reassignments::ScaffoldingCompletelyConcreteTangibleThingsReassignmentSerializer < ActiveModel::Serializer
  attributes :id,
    :membership_id,
    :membership_ids,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at
end
