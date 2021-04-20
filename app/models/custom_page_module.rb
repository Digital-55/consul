class CustomPageModule < ApplicationRecord
  belongs_to :custom_page
  scope :subtitle, -> { where(type: 'Subtitle') }
  scope :claim, -> { where(type: 'Claim') }
end
