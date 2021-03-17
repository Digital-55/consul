class Menu < ApplicationRecord
  validates :title, presence: true
  validates :section, presence: true

  scope :header, -> { where(section: 'header') }
  scope :footer, -> { where(section: 'footer') }
end
