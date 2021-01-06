class AddRolesToScaffoldingAbsolutelyAbstractCreativeConceptsCollaborators < ActiveRecord::Migration[6.1]
  def change
    add_column :scaffolding_absolutely_abstract_creative_concepts_collaborators, :roles, :jsonb, default: []
  end
end
