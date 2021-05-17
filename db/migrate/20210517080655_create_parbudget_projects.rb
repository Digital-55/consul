class CreateParbudgetProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_projects do |t|
      t.string :denomination
      t.integer :code
      t.integer :year
      t.belongs_to :ambit, index: true, foreign_key: true
      t.integer :votes
      t.integer :cost
      t.string :author
      t.string :email
      t.string :phone
      t.string :association
      t.string :url
      t.text :descriptive_memory
      t.belongs_to :topic, index: true, foreign_key: true
      t.string :entity_association
      t.belongs_to :responsible, index: true, foreign_key: true
      t.belongs_to :local_forum, index: true, foreign_key: true
      t.boolean :plate_proceeds
      t.boolean :license_plate
      t.string :plate_installed
      t.boolean :assumes_dgpc
      t.integer :code_old
      t.timestamps null: false
    end
  end
end
