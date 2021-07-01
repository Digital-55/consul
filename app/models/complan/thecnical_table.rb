class Complan::ThecnicalTable < ApplicationRecord
    belongs_to :complan_performance, class_name: "Complan::Performance", foreign_key: "complan_performance_id"
    has_many :complan_assistants, foreign_key: "complan_thecnical_table_id", class_name: "Complan::Assistant", dependent: :destroy


    self.table_name = "complan_thecnical_tables"

    def self.get_columns
        [
            :date,
            :name,
            :description,
            :year,
            :date_agreement
        ]
    end

    def self.get_exporter
        [
            :date,
            :description,
            :name,
            :performance,
            :year,
            :type,
            :date_agreement,
            :session
        ]
    end
   
end

