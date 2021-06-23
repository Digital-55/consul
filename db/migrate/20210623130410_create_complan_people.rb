class CreateComplanPeople < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_people do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :position
      t.string :address
      #reference center

      t.timestamps null: false
    end
  end
end
