class CreateComplanLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_locations do |t|
      t.string :district
      t.string :borought
      t.string :address
      #reference financing

      t.timestamps null: false
    end
  end
end
