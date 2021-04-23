class CustomPageModule < ApplicationRecord
  belongs_to :custom_page
  scope :subtitle, -> { where(type: 'SubtitleModule') }
  scope :claim, -> { where(type: 'ClaimModule') }
  scope :rich_text, -> { where(type: 'RichTextModule') }
end
