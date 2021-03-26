class Menu < ApplicationRecord
  has_many :menu_items, inverse_of: :menu, dependent: :destroy
  accepts_nested_attributes_for :menu_items, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validates :section, presence: true

  before_save :set_unique_published_menu

  scope :header, -> { where(section: 'header') }
  scope :footer, -> { where(section: 'footer') }
  scope :sorted, -> { order(published: :desc, updated_at: :desc) }

  def set_unique_published_menu
    (Menu.where(published: true, section: section) - [self]).each{ |menu| menu.update_column(:published, false) } if published
  end

end
