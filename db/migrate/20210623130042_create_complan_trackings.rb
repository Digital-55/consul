class CreateComplanTrackings < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_trackings do |t|
      #reference performance

      t.timestamps null: false
    end
  end
end
