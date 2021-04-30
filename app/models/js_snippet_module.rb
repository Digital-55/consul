class JSSnippetModule < CustomPageModule
  belongs_to :custom_page
  TEXT_MAX_LENGTH = 5000
  validates :js_snippet, presence: true, length: { maximum: TEXT_MAX_LENGTH }
end