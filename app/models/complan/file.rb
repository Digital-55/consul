class Complan::File < ApplicationRecord
    belongs_to :complan_financing, class_name: "Complan::Financing", foreign_key: "complan_financing_id"


    self.table_name = "complan_files"  
end

