class CreateCustomPages < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_pages do |t|
      t.string :title
      t.string :parent_slug
      t.string :slug
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.boolean :canonical
      t.boolean :published
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
