class CustomPage < ApplicationRecord
  has_many :custom_page_modules
  has_many :subtitles, class_name: 'SubtitleModule'
  has_many :claims, class_name: 'ClaimModule'
  has_many :rich_texts, class_name: 'RichTextModule'
  has_many :youtubes, class_name: 'YoutubeModule'
  has_many :ctas, class_name: 'CTAModule'
  has_many :js_snippets, class_name: 'JSSnippetModule'
  has_many :custom_images, class_name: 'CustomImageModule'
  has_many :promotionals, class_name: 'PromotionalModule'
  accepts_nested_attributes_for :custom_page_modules, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :subtitles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :claims, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :rich_texts, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :youtubes, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :ctas, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :js_snippets, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :custom_images, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :promotionals, allow_destroy: true, reject_if: :all_blank

  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9-]+$\z/i }
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published:false) }
  scope :sorted, -> { order(updated_at: :desc) }
end
