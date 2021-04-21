class RichText < CustomPageModule
  belongs_to :custom_page
  TEXT_MAX_LENGTH = 5000
  validates :rich_text, presence: true
  validates :rich_text, length: { maximum: TEXT_MAX_LENGTH }

end