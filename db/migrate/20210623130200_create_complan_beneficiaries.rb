class CreateComplanBeneficiaries < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_beneficiaries do |t|
      t.text :description
      t.integer :count_participants
      t.integer :count_men
      t.integer :count_women
      #reference performance

      t.timestamps null: false
    end
  end
end
