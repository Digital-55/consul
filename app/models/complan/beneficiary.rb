class Complan::Beneficiary < ApplicationRecord
    belongs_to :complan_performance, class_name: "Complan::Performance", foreign_key: "complan_performance_id"
    has_many :complan_beneficiaries_typologies, foreign_key: "complan_beneficiary_id", class_name: "Complan::BeneficiariesTypology", dependent: :destroy

    self.table_name = "complan_beneficiaries"   
end

