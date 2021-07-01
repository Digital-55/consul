class CreateComplanCreditModifications < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_credit_modifications do |t|
      t.string :departure_destination
      t.string :number_file
      t.date :mc_accept
      t.date :of_remission
      t.date :posted
      t.string :count_credit
      t.string :ad_aprobed
      t.string :o_aprobed
      #reference import

      t.timestamps null: false
    end
  end
end
