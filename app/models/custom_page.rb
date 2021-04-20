class CustomPage < ApplicationRecord
  has_many :custom_page_modules
  has_many :subtitles, class_name: 'Subtitle'
  has_many :claims, class_name: 'Claim'
  accepts_nested_attributes_for :custom_page_modules, allow_destroy: true, reject_if: :all_blank

  validates :slug, uniqueness: true
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published:false) }
  scope :sorted, -> { order(updated_at: :desc) }
end
