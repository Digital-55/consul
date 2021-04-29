class CreateCustomPageModules < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_page_modules do |t|
      t.integer :custom_page_id
      t.string :type
      t.integer :position, default: 0
      t.boolean :disabled, default: false
      t.string :subtitle
      t.string :claim
      t.text :rich_text
      t.string :youtube_url
      t.string :cta_text
      t.string :cta_button
      t.string :cta_link

      t.timestamps
    end
    add_index :custom_page_modules, [:type, :custom_page_id]
  end
end
