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
      t.text :js_snippet
      t.attachment :custom_image
      t.text :custom_image_alt
      t.string :promo_title_one
      t.text :promo_description_one
      t.attachment :promo_image_one
      t.string :promo_link_one
      t.string :promo_title_two
      t.text :promo_description_two
      t.attachment :promo_image_two
      t.string :promo_link_two
      t.string :promo_title_three
      t.text :promo_description_three
      t.attachment :promo_image_three
      t.string :promo_link_three

      t.timestamps
    end
    add_index :custom_page_modules, [:type, :custom_page_id]
  end
end
