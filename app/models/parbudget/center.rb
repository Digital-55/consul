class Parbudget::Center < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project"
    has_many :parbudget_responsibles, class_name: "Parbudget::Responsible"

    self.table_name = "parbudget_centers"
end

