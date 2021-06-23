class CreateComplanBeneficiariesTypologies < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_beneficiaries_typologies do |t|
      #reference beneficiary
      #reference typology

      t.timestamps null: false
    end
  end
end
