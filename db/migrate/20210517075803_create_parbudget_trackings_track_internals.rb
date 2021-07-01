class CreateParbudgetTrackingsTrackInternals < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_track_ints do |t|
      t.belongs_to :parbudget_tracking_internal, index: true, foreign_key: true
      t.belongs_to :parbudget_tracking, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
