class CreateParbudgetTrackingsTrackExternals < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_trackings_track_externals do |t|
      t.belongs_to :tracking_external, index: true, foreign_key: true
      t.belongs_to :tracking, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
