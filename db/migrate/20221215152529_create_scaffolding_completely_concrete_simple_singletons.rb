class CreateScaffoldingCompletelyConcreteSimpleSingletons < ActiveRecord::Migration[7.0]
  def change
    create_table :scaffolding_completely_concrete_simple_singletons do |t|
      t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: "scaffolding_absolutely_abstract_creative_concepts"}, index: {name: "index_simple_singletons_on_creative_concept_id"}
      t.string :name

      t.timestamps
    end
  end
end
