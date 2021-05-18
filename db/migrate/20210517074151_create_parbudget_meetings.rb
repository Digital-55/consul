class CreateParbudgetMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_meetings do |t|
      t.text :reason
      t.string :who_requests
      t.timestamps :date

      t.timestamps null: false
    end
  end
end
