class Complan::Performance < ApplicationRecord
    belongs_to :complan_project, class_name: "Complan::Project", foreign_key: "complan_project_id"
    belongs_to :complan_financing, class_name: "Complan::Financing", foreign_key: "complan_financing_id"
    has_many :complan_activities, foreign_key: "complan_performance_id", class_name: "Complan::Activity", dependent: :destroy
    has_many :complan_trackings, foreign_key: "complan_performance_id", class_name: "Complan::Tracking", dependent: :destroy
    has_many :complan_medias, foreign_key: "complan_performance_id", class_name: "Complan::Media", dependent: :destroy



    self.table_name = "complan_performances"

    def self.get_columns
        [
           
        ]
    end
   
end

