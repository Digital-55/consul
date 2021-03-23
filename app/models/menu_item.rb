class MenuItem < ApplicationRecord
  belongs_to :menu
  validates :title, presence: true
end
