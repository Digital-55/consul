class Complan::Performance < ApplicationRecord
    belongs_to :complan_project, class_name: "Complan::Project", foreign_key: "complan_project_id"
    belongs_to :complan_financing, class_name: "Complan::Financing", foreign_key: "complan_financing_id"
    has_many :complan_activities, foreign_key: "complan_performance_id", class_name: "Complan::Activity", dependent: :destroy
    has_many :complan_trackings, foreign_key: "complan_performance_id", class_name: "Complan::Tracking", dependent: :destroy
    has_many :complan_medias, foreign_key: "complan_performance_id", class_name: "Complan::Media", dependent: :destroy
    has_many :complan_ambits, foreign_key: "complan_performance_id", class_name: "Complan::Ambit", dependent: :destroy
    has_many :complan_beneficiaries, foreign_key: "complan_performance_id", class_name: "Complan::Beneficiary", dependent: :destroy
    has_many :complan_thecnical_tables, foreign_key: "complan_performance_id", class_name: "Complan::ThecnicalTable", dependent: :destroy
    has_many :complan_indicators, foreign_key: "complan_performance_id", class_name: "Complan::Indicator", dependent: :destroy

    self.table_name = "complan_performances"

    def self.get_columns
        [
            :type_performance,
            :status,
            :start_date,
            :end_date,
            :viability,
            :vulnerability_index,
            :description
        ]
    end

    def self.get_exporter
        [
            :type_performance,
            :description_export,
            :project,
            :financing,
            :comments_export,
            :start_date,
            :end_date,
            :status,
            :annuity,
            :valued,
            :viability,
            :vulnerability_index
            :edition,
            :multi_year
        ]
    end

    def project
        self.complan_project.try(:name)
    end

    def financing
        "#{self.complan_financing.try(:type_financing)} - #{self.complan_financing.try(:type_subfinancing)}"
    end

    def description_export
        Nokogiri::HTML(description).text
    rescue
        ""
    end

    def comments_export
        Nokogiri::HTML(comments).text
    rescue
        ""
    end
   
end

