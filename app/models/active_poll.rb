class ActivePoll < ApplicationRecord
  include Measurable

  translates :description, touch: true
  include Globalizable

  def self.translate_column_names
    [:description ]
  end
end
