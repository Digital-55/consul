class CreateParbudgetAmbits < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_ambits do |t|
      t.string :name
      t.integer :code
    
      t.timestamps null: false
    end
  end
end
