class Parbudget::Center < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project"
    has_many :parbudget_responsibles, foreign_key: "parbudget_center_id", class_name: "Parbudget::Responsible", dependent: :destroy

    self.table_name = "parbudget_centers"

    accepts_nested_attributes_for :parbudget_responsibles, allow_destroy: true

    validates :code, :code_section, :code_program, :denomination, presence: true

    validates_associated :parbudget_responsibles

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

    def get_list
        [
            self.id,
            self.denomination,
            self.code,
            self.code_section,
            self.code_program,
            self.responsible,
            self.government_area,
            self.general_direction
        ]
    end

    def project
        self.try(:parbudget_project).try(:denomination)
    end
end

