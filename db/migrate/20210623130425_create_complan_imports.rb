class CreateComplanImports < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_imports do |t|
      t.float :import
      t.string :type_import
      t.string :annuity
      t.float :import_start_assing
      t.float :import_requested
      t.float :import_remaining
      #reference financing
      #reference center

      t.timestamps null: false
    end
  end
end
