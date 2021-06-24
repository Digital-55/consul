class Complan::Project < ApplicationRecord
    belongs_to :complan_strategy, class_name: "Complan::Strategy", foreign_key: "complan_strategy_id"


    self.table_name = "complan_projects"

    def self.get_columns
        [
           
        ]
    end
   
end

