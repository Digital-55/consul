class Sures::CustomizeCard < ApplicationRecord
  include Imageable
  belongs_to :page, class_name: "SiteCustomization::Page", foreign_key: "site_customization_page_id"

  # table_name must be set before calls to 'translates'
  self.table_name = "sures_customize_cards"

  translates :label,       touch: true
  translates :title,       touch: true
  translates :description, touch: true
  translates :link_text,   touch: true
  include Globalizable

  def self.header
    where(header: true)
  end

  def self.body
    where(header: false, site_customization_page_id: nil).order(:created_at)
  end

  def self.translate_column_names
    [:title, :description, :label, :link_text ]
  end
end
