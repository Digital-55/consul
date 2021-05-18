class Parbudget::TrackInt < ApplicationRecord
    belongs_to :parbudget_tracking_internal, class_name: "Parbudget::TrackingInternal"
    belongs_to :parbudget_tracking, class_name: "Parbudget::Tracking"

    self.table_name = "parbudget_track_ints"

   
end

