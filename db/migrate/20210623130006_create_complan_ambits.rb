class CreateComplanAmbits < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_ambits do |t|
      t.text :description
      #reference performance

      t.timestamps null: false
    end
  end
end
