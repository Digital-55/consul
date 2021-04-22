class MenuItem < ApplicationRecord
  belongs_to :menu, touch: true
  has_many :menu_items
  accepts_nested_attributes_for :menu_items, allow_destroy: true, reject_if: :all_blank

  validates :title, presence: true
  validate :url_format
  validate :title_format

  scope :enabled, -> { where(disabled: false) }

  def title_format
    self.errors.add :title, "format is invalid!" unless title_valid?
  end

  def title_valid?
    !!title.match(/^[[:alnum:]\s]*$/u)
  end

  def url_format
    self.errors.add :url, "format is invalid!" unless url_valid? || url.blank?
  end

  def url_valid?
    # !!url.match(/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-=\?]*)*\/?$/) &&
    !!url.match(URI::regexp)
  end
end
