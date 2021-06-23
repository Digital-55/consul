class CreateComplanCreditIndicators < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_indicators do |t|
      t.string :name
      t.text :description
      t.integer :numeric_value
      t.integer :provided
      t.integer :done
      #reference performance

      t.timestamps null: false
    end
  end
end
