class CreateSgGenerics < ActiveRecord::Migration[5.0]
  def change
    create_table :sg_generics do |t|
      t.string :title
      t.string :generic_type

      t.timestamps null: false
    end
  end
end
