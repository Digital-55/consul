class CreateParbudgetCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_centers do |t|
      t.string :denomination
      t.string :code
      t.string :code_section
      t.string :code_program
      t.string :responsible
      t.string :government_area
      t.string :general_direction
      t.belongs_to :project, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
