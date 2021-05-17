class CreateParbudgetTrackingExternals < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_tracking_externals do |t|
      t.string :code
      t.string :status
      t.timestamps :date
      t.text :status_description

      t.timestamps null: false
    end
  end
end
