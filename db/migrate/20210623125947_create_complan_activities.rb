class CreateComplanActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_activities do |t|
      t.text :description
      t.string :activity
      #reference performance

      t.timestamps null: false
    end
  end
end
