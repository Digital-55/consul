class CreateCustomPageModules < ActiveRecord::Migration[5.0]
  def up
    create_table :custom_page_modules do |t|
      t.integer :custom_page_id
      t.string :type
      t.integer :position, default: 0
      t.boolean :disabled, default: false
      t.string :subtitle
      t.text :claim
      t.text :rich_text
      t.string :youtube_url
      t.text :youtube_text
      t.string :youtube_text_position
      t.text :cta_text
      t.attachment :cta_image
      t.string :cta_button
      t.string :cta_button_color
      t.string :cta_text_button_color
      t.string :cta_link
      t.string :cta_overlay_color
      t.string :cta_overlay_opacity
      t.string :cta_height_position
      t.string :cta_width_position
      t.text :js_snippet
      t.attachment :custom_image
      t.text :custom_image_alt
      t.string :promo_location_one
      t.string :promo_title_one
      t.text :promo_description_one
      t.attachment :promo_image_one
      t.string :promo_alt_image_one
      t.string :promo_link_one
      t.string :promo_location_two
      t.string :promo_title_two
      t.text :promo_description_two
      t.attachment :promo_image_two
      t.string :promo_alt_image_two
      t.string :promo_link_two
      t.string :promo_location_three
      t.string :promo_title_three
      t.text :promo_description_three
      t.attachment :promo_image_three
      t.string :promo_alt_image_three
      t.string :promo_link_three
      t.attachment :list_icon_one
      t.string :list_title_one
      t.text :list_description_one
      t.attachment :list_icon_two
      t.string :list_title_two
      t.text :list_description_two
      t.attachment :list_icon_three
      t.string :list_title_three
      t.text :list_description_three

      t.timestamps
    end
    add_index :custom_page_modules, [:type, :custom_page_id]

    SiteCustomization::Page.published.each do |page|
      cp = CustomPage.create(
                              title: page.title,
                              slug: page.slug.humanize.parameterize,
                              published: page.status == "published" ? true : false
                            )
      position = 0
      cp.subtitles.build(subtitle: page.subtitle, position: position += 1).save if page.subtitle.present?
      cp.rich_texts.build(rich_text: page.content, position: position += 1).save if page.content.present?
      page.update_column(:status, "draft")
    end
  end

  def down
    CustomPage.published.each do |custom_page|
      page = SiteCustomization::Page.find_by(slug: custom_page.slug) ||
             SiteCustomization::Page.find_by(slug: custom_page.slug.underscore)
      page.update_column(:status, "published") if page.present?
    end

    drop_table :custom_page_modules
  end

end
