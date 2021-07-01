class CreateParbudgetEconomicBudgets < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_economic_budgets do |t|
      t.integer :year
      t.decimal :import
      t.date :start_date
      t.date :end_date
      t.string :count_managing_body
      t.string :count_functional
      t.string :economic
      t.string :element_pep
      t.string :financing
      t.string :type_contract
      t.belongs_to :parbudget_project, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
