class CreateParbudgetTrackings < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_trackings do |t|
      #t.belongs_to :parbudget_project, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
