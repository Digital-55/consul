class Parbudget::TrackingExternal < ApplicationRecord
    has_and_belongs_to_many :parbudget_track_ext, class_name: "Parbudget::TrackExt"
    has_and_belongs_to_many :parbudget_trackings, :through => :parbudget_track_ext,  class_name: "Parbudget::Tracking"

    self.table_name = "parbudget_tracking_externals"

   
end

