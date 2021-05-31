class CreateSgTableOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :sg_table_orders do |t|
      t.string :table_name
      t.integer :order, default: 0
      t.references :sg_generic, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
