class CTAModule < CustomPageModule
  belongs_to :custom_page
  TEXT_MAX_LENGTH = 5000
  IMAGE_WIDTH = 1230
  has_attached_file :cta_image,
                    url: "/system/cta_images/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/cta_images/:id/:style_:basename.:extension",
                    styles: { content: "800>", large: "1230x", thumb: "118x100#" }
  validates_attachment_size :cta_image, less_than: 2.megabytes
  validates_attachment_content_type :cta_image, content_type: /\Aimage/
  validate :link_format

  def link_format
    self.errors.add :cta_link, "format is invalid!" unless cta_link_valid? || cta_link.blank?
  end

  def cta_link_valid?
    !!cta_link.match(URI::regexp)
  end
end