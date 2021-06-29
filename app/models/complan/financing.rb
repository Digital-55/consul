class Complan::Financing < ApplicationRecord
    has_many :complan_files, foreign_key: "complan_financing_id", class_name: "Complan::File", dependent: :destroy
    has_many :complan_imports, foreign_key: "complan_financing_id", class_name: "Complan::Import", dependent: :destroy
    has_many :complan_performances, foreign_key: "complan_financing_id", class_name: "Complan::Performance", dependent: :destroy

    self.table_name = "complan_financings"

    def self.get_columns
        [
            :start_year,
            :type_financing,
            :type_subfinancing
        ]
    end
   
    def self.get_exporter
        [
            :start_year,
            :type_financing,
            :type_subfinancing
        ]
    end
end

