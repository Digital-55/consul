class SiteCustomization::ContentBlock < ApplicationRecord
  VALID_BLOCKS = %w[top_links footer subnavigation_left subnavigation_right]

  validates :locale, presence: true, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validates :name, presence: true, uniqueness: { scope: :locale }, inclusion: { in: VALID_BLOCKS }

  def self.block_for(name, locale)
    locale ||= :es
    find_by(name: name, locale: locale).try(:body)
  end
end
