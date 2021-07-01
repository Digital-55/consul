class CreateParbudgetTrackingInternals < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_tracking_internals do |t|
      t.text :observations
      t.timestamps :date
      t.boolean :file_send, :default => false
      t.boolean :file_recived, :default => false
      t.boolean :file_edited, :default => false

      t.timestamps null: false
    end
  end
end
