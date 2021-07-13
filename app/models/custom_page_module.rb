class CustomPageModule < ApplicationRecord
  belongs_to :custom_page
  scope :subtitle, -> { where(type: 'SubtitleModule') }
  scope :claim, -> { where(type: 'ClaimModule') }
  scope :rich_text, -> { where(type: 'RichTextModule') }
  scope :youtube, -> { where(type: 'YoutubeModule') }
  scope :cta, -> { where(type: 'CTAModule') }
  scope :custom_image, -> { where(type: 'CustomImageModule') }
  scope :promotional, -> { where(type: 'PromotionalModule') }
  scope :list, -> { where(type: 'ListModule') }
  scope :enabled, -> { where(disabled: false)}
  scope :sorted, -> { order(position: :asc, updated_at: :desc) }

  after_save do
    custom_page&.update_attribute(:updated_at, Time.now)
  end
end
