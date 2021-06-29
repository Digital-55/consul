class Complan::Import < ApplicationRecord
    belongs_to :complan_financing, class_name: "Complan::Financing", foreign_key: "complan_financing_id"
    belongs_to :complan_center, class_name: "Complan::Center", foreign_key: "complan_center_id"
    has_many :complan_credit_modifications, foreign_key: "complan_import_id", class_name: "Complan::CreditModification", dependent: :destroy


    self.table_name = "complan_imports"   
end

