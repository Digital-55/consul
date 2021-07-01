class ChangeFieldDateMeeting < ActiveRecord::Migration[5.0]
  def change
   add_column :parbudget_meetings, :date_at, :datetime
  end
end
