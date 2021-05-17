class CreateParbudgetTrackingsTrackInternals < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_trackings_track_internals do |t|
      t.belongs_to :tracking_internal, index: true, foreign_key: true
      t.belongs_to :tracking, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
