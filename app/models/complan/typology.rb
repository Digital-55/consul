class Complan::Typology < ApplicationRecord
    has_many :complan_beneficiaries_typologies, foreign_key: "complan_typology_id", class_name: "Complan::BeneficiariesTypology", dependent: :destroy

    self.table_name = "complan_typologies"

    def self.get_columns
        [
           
        ]
    end
   
end

