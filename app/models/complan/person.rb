class Complan::Person < ApplicationRecord
    belongs_to :complan_center class_name: "Complan::Center", foreign_key: "complan_center_id"


    self.table_name = "complan_people"   
end

