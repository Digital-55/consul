class Parbudget::Responsible < ApplicationRecord
    belongs_to :parbudget_center, class_name: "Parbudget::Center"
    has_many :parbudget_projects, class_name: "Parbudget::Project"

    

    self.table_name = "parbudget_responsibles"

   
end

