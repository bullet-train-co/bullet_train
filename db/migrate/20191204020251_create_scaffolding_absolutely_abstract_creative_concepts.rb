class CreateScaffoldingAbsolutelyAbstractCreativeConcepts < ActiveRecord::Migration[6.0]
  def change
    create_table :scaffolding_absolutely_abstract_creative_concepts do |t|
      t.references :team, null: false, foreign_key: true, index: {name: "index_absolutely_abstract_creative_concepts_on_team_id"}
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
