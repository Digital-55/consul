class CreateComplanThecnicalTables < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_thecnical_tables do |t|
      t.date :date_at
      t.text :description
      t.string :name
      t.string :year
      t.string :type
      t.date :date_agreement
      t.string :sesion
      #reference performance

      t.timestamps null: false
    end
  end
end
