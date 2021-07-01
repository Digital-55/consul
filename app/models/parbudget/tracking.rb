class Parbudget::Tracking < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project"

    has_and_belongs_to_many :parbudget_track_int, class_name: "Parbudget::TrackInt"
    has_and_belongs_to_many :parbudget_tracking_internals, :through => :parbudget_track_int,  class_name: "Parbudget::TrackingInternal"
    has_and_belongs_to_many :parbudget_track_ext, class_name: "Parbudget::TrackExt"
    has_and_belongs_to_many :parbudget_tracking_externals, :through => :parbudget_track_ext,  class_name: "Parbudget::TrackingExternal"
    has_and_belongs_to_many :parbudget_tracking_meeting, class_name: "Parbudget::TrackingMeeting"
    has_and_belongs_to_many :parbudget_meetings, :through => :parbudget_tracking_meeting,  class_name: "Parbudget::Meeting"
    

    self.table_name = "parbudget_trackings"
end

