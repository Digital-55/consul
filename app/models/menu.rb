class Menu < ApplicationRecord
  validates :title, presence: true
  validates :section, presence: true

  before_save :set_unique_published_menu

  scope :header, -> { where(section: 'header') }
  scope :footer, -> { where(section: 'footer') }
  scope :sorted, -> { order(published: :desc, updated_at: :desc) }

  def set_unique_published_menu
    if published
      Menu.where(published: true, section: section).each{ |menu| menu.update_column(:published, false) }
    end
  end
end
