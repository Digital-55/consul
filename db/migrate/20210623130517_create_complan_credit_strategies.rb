class CreateComplanCreditStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_strategies do |t|
      t.string :name
      t.string :departure
      t.text :description
      t.date :approbal_date

      t.timestamps null: false
    end
  end
end
