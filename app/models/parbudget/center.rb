class Parbudget::Center < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project"
    has_many :parbudget_responsibles, class_name: "Parbudget::Responsible"

    self.table_name = "parbudget_centers"

    def self.get_columns
        [
            :code,
            :code_section,
            :code_program,
            :denomination,
            :responsible
        ]
    end

    def self.get_exporter
        [
            :code,
            :code_section,
            :code_program,
            :denomination,
            :responsible,
            :government_area,
            :general_direction,
            :project
        ]
    end

    def project
        self.try(:parbudget_project).try(:denomination)
    end
end

