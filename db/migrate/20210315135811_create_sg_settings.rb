class CreateSgSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :sg_settings do |t|
      t.string :title
      t.string :setting_type
      t.string :data_type
      t.boolean :active
      
      t.timestamps null: false
    end
  end
end
