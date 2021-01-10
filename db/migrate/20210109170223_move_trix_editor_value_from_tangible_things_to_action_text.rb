class MoveTrixEditorValueFromTangibleThingsToActionText < ActiveRecord::Migration[6.1]
  def change
    Scaffolding::CompletelyConcrete::TangibleThing.find_each do |tangible_thing|
      next tangible_thing.trix_editor_value.blank?

      tangible_thing.update(action_text_value: tangible_thing.trix_editor_value)
    end

    remove_column :scaffolding_completely_concrete_tangible_things, :trix_editor_value
  end
end
