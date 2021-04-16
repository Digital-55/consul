class CustomPage < ApplicationRecord
  validates :slug, uniqueness: true

  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published:false) }
  scope :sorted, -> { order(updated_at: :desc) }
end
