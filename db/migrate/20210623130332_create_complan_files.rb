class CreateComplanFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_files do |t|
      t.string :number_file
      t.string :type_file
      t.date :proposal_date
      t.date :start_date
      t.date :approval_date
      t.date :accounting_date

      #reference financing

      t.timestamps null: false
    end
  end
end
