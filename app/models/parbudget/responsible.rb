class Parbudget::Responsible < ApplicationRecord
    belongs_to :parbudget_center, class_name: "Parbudget::Center"
    has_many :parbudget_projects, class_name: "Parbudget::Project"

    

    self.table_name = "parbudget_responsibles"


    def self.get_columns
        [
            :full_name,
            :phone,
            :email,
            :position,
            :center
        ]
    end

    def self.get_exporter
        [
            :full_name,
            :phone,
            :email,
            :position,
            :center
        ]
    end

    def center
        self.try(:parbudget_center).try(:denomination)
    end
   
end

