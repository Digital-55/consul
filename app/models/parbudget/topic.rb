class Parbudget::Topic < ApplicationRecord

    validates :name, presence: true

    self.table_name = "parbudget_topics"

    def self.get_columns
        [
            :name
        ]
    end
end

