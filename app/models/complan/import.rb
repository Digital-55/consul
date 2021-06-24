class Complan::Import < ApplicationRecord
    belongs_to :complan_financing, class_name: "Complan::Financing", foreign_key: "complan_financing_id"
    belongs_to :complan_center, class_name: "Complan::Center", foreign_key: "complan_center_id"


    self.table_name = "complan_imports"   
end

