class Menu < ApplicationRecord
  validates :title, presence: true
  validates :section, presence: true

  before_save :set_unique_enabled_menu

  scope :header, -> { where(section: 'header') }
  scope :footer, -> { where(section: 'footer') }
  scope :sorted, -> { order(enabled: :desc, updated_at: :desc) }

  def set_unique_enabled_menu
    if enabled
      Menu.where(enabled: true, section: section).each{ |menu| menu.update_column(:enabled, false) }
    end
  end
end
