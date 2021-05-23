class CreateSgTableFields < ActiveRecord::Migration[5.0]
  def change
    create_table :sg_table_fields do |t|
      t.string :table_name
      t.string :field_name
      t.references :sgeneric, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end
