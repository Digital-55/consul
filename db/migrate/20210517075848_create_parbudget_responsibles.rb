class CreateParbudgetResponsibles < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_responsibles do |t|
      t.string :full_name
      t.string :phone
      t.string :email
      t.string :position
      t.belongs_to :center, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
