class Parbudget::TrackingInternal < ApplicationRecord
    has_and_belongs_to_many :parbudget_track_int, class_name: "Parbudget::TrackInt"
    has_and_belongs_to_many :parbudget_trackings, :through => :parbudget_track_int,  class_name: "Parbudget::Tracking"

    self.table_name = "parbudget_tracking_internals"

   
end

