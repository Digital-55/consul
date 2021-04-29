class CTAModule < CustomPageModule
  belongs_to :custom_page
  validates :cta_text, presence: true
  validate :link_format

  def link_format
    self.errors.add :cta_link, "format is invalid!" unless cta_link_valid? || cta_link.blank?
  end

  def cta_link_valid?
    !!cta_link.match(URI::regexp)
  end
end