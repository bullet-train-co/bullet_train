class MoveTrixEditorValueFromTangibleThingsToActionText < ActiveRecord::Migration[6.1]
  def change
    Scaffolding::CompletelyConcrete::TangibleThing.find_each do |tangible_thing|
      if tangible_thing.trix_editor_value.present?
        tangible_thing.update(action_text_value: tangible_thing.trix_editor_value)
      end
    end

    remove_column :scaffolding_completely_concrete_tangible_things, :trix_editor_value
  end
end
