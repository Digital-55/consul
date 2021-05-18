class CreateParbudgetTrackingsTrackExternals < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_track_exts do |t|
      t.belongs_to :parbudget_tracking_external, index: true, foreign_key: true
      t.belongs_to :parbudget_tracking, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
