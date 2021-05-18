class Parbudget::Meeting < ApplicationRecord
    has_many :parbudget_assistants, class_name: "Parbudget::Assistant"

    has_and_belongs_to_many :parbudget_tracking_meetings, class_name: "Parbudget::TrackingMeeting"
    has_and_belongs_to_many :parbudget_trackings, :through => :parbudget_tracking_mettings,  class_name: "Parbudget::Tracking"

    self.table_name = "parbudget_meetings"
end

