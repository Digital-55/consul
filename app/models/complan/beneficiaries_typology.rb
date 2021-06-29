class Complan::BeneficiariesTypology < ApplicationRecord
    belongs_to :complan_beneficiary, class_name: "Complan::Beneficiary", foreign_key: "complan_beneficiary_id"
    belongs_to :complan_typology, class_name: "Complan::Typology", foreign_key: "complan_typology_id"


    self.table_name = "complan_beneficiaries_typologies"
end

