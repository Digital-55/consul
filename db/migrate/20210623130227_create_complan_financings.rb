class CreateComplanFinancings < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_financings do |t|
      t.integer :start_year
      t.string :type_financing
      t.string :type_subfinancing

      t.timestamps null: false
    end
  end
end
