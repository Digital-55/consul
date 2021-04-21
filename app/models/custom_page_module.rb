class CustomPageModule < ApplicationRecord
  belongs_to :custom_page
  scope :subtitle, -> { where(type: 'Subtitle') }
  scope :claim, -> { where(type: 'Claim') }
  scope :rich_text, -> { where(type: 'RichText') }
end
