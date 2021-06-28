class CreateCustomPageModules < ActiveRecord::Migration[5.0]
  def up
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
