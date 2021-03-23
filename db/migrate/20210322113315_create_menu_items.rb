class CreateMenuItems < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_items do |t|
      t.string :title
      t.string :url
      t.integer :position, default: 0
      t.string :target
      t.boolean :editable, default: true
      t.boolean :enabled, default: false
      t.references :menu, foreign_key: true

      t.timestamps
    end
  end
end
