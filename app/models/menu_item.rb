class MenuItem < ApplicationRecord
  belongs_to :menu
  has_many :menu_items
  accepts_nested_attributes_for :menu_items, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
end
