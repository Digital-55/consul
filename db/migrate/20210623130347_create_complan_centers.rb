class CreateComplanCenters < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_centers do |t|
      t.string :organism
      t.string :dg
      t.string :sg
      t.string :denomination
      t.string :address


      t.timestamps null: false
    end
  end
end
