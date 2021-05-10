class CustomPageModule < ApplicationRecord
  belongs_to :custom_page
  scope :subtitle, -> { where(type: 'SubtitleModule') }
  scope :claim, -> { where(type: 'ClaimModule') }
  scope :rich_text, -> { where(type: 'RichTextModule') }
  scope :youtube, -> { where(type: 'YoutubeModule') }
  scope :cta, -> { where(type: 'CTAModule') }
  scope :custom_image, -> { where(type: 'CustomImageModule') }
  scope :promotional, -> { where(type: 'PromotionalModule') }
  scope :enabled, -> { where(disabled: false)}
end
