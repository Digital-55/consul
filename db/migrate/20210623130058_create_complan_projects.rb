class CreateComplanProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_projects do |t|
      t.string :name
      t.text :description
      #reference strategy

      t.timestamps null: false
    end
  end
end
