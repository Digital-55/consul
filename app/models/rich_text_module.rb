class RichTextModule < CustomPageModule
  belongs_to :custom_page
  TEXT_MAX_LENGTH = 5000
  validates :rich_text, presence: true, length: { maximum: TEXT_MAX_LENGTH }
end