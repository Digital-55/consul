class Complan::CreditModification < ApplicationRecord
    belongs_to :complan_import, class_name: "Complan::Import", foreign_key: "complan_import_id"


    self.table_name = "complan_credit_modifications"   
end

