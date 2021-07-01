class Complan::Reader < ApplicationRecord
    belongs_to :user, touch: true
    delegate :name, :email, :name_and_email, to: :user, allow_nil: true
  
    validates :user_id, presence: true, uniqueness: true

    self.table_name = "complan_readers"
end
