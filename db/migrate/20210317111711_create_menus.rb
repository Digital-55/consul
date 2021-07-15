class CreateMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :menus do |t|
      t.string :title
      t.string :section
      t.boolean :published, default: false
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
