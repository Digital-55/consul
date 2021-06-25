class Complan::Strategy < ApplicationRecord
    has_many :complan_projects, foreign_key: "complan_strategy_id", class_name: "Complan::Project", dependent: :destroy

    self.table_name = "complan_strategies"

    def self.get_columns
        [
           
        ]
    end
   
end

