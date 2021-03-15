class CreateSgSelects < ActiveRecord::Migration[5.0]
  def change
    create_table :sg_selects do |t|
      t.string :key
      t.string :value
      t.jsonb :data
      t.references :sg_setting, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
