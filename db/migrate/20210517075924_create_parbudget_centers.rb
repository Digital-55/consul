class CreateParbudgetCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_centers do |t|
      t.string :denomination
      t.string :code
      t.string :email
      t.string :position
      t.belongs_to :center, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
