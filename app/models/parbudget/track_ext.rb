class Parbudget::TrackExt < ApplicationRecord
    belongs_to :parbudget_tracking_external, class_name: "Parbudget::TrackingExternal"
    belongs_to :parbudget_tracking, class_name: "Parbudget::Tracking"

    self.table_name = "parbudget_track_exts"

   
end

