class DeleteFieldProjectAssociation < ActiveRecord::Migration[5.0]
  def change
    remove_column :parbudget_projects, :association
    rename_column :parbudget_projects, :entity_association, :entity
  end
end
