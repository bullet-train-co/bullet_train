# This migration comes from bullet_train_outgoing_webhooks_engine (originally 20221130063357)
class AddCreativeConceptToEndpoints < ActiveRecord::Migration[7.0]
  def change
    add_reference(
      :webhooks_outgoing_endpoints,
      :scaffolding_absolutely_abstract_creative_concept,
      foreign_key: true,
      index: {name: "index_endpoints_on_abstract_creative_concept_id"}
    )
  end
end
