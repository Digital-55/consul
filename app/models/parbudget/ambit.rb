class Parbudget::Ambit < ApplicationRecord
    
    validates :name,:code, presence: true

    self.table_name = "parbudget_ambits"

    def self.get_columns
        [
            :name,
            :code
        ]
    end
   
end

