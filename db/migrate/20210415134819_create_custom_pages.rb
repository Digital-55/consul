class CreateCustomPages < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_pages do |t|
      t.string :title
      t.string :slug
      t.boolean :published

      t.timestamps
    end
  end
end
