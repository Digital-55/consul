class Parbudget::TrackingsMeeting < ApplicationRecord
    belongs_to :parbudget_meeting, class_name: "Parbudget::Meeting"
    belongs_to :parbudget_tracking, class_name: "Parbudget::Tracking"

    self.table_name = "parbudget_trackings_meetings"

   
end

