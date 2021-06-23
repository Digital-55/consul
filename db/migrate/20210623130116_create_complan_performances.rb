class CreateComplanPerformances < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_performances do |t|
      t.string :type_performance
      t.text :description
      t.text :comments
      t.date :start_date
      t.date :end_date
      t.string :status
      t.integer :annuity
      t.integer :valued
      t.integer :vulnerability_index
      t.integer :edition
      t.integer :multi_year
      #reference project
      #reference financing

      t.timestamps null: false
    end
  end
end
