class Parbudget::Meeting < ApplicationRecord
    require 'nokogiri'
    has_many :parbudget_assistants, class_name: "Parbudget::Assistant", foreign_key: "parbudget_meeting_id", dependent: :destroy

    # has_and_belongs_to_many :parbudget_tracking_meetings, class_name: "Parbudget::TrackingMeeting"
    # has_and_belongs_to_many :parbudget_trackings, :through => :parbudget_tracking_mettings,  class_name: "Parbudget::Tracking"

    accepts_nested_attributes_for :parbudget_assistants, reject_if: :all_blank, allow_destroy: true

    validates :date_at, :who_requests, :reason, presence: true
    validates_associated :parbudget_assistants

    scope :pending, -> { where("date_at >= to_date(?,'YYYY-MM-DD')", Time.zone.now) }
    scope :done, -> { where("date_at < to_date(?,'YYYY-MM-DD')", Time.zone.now) }


    self.table_name = "parbudget_meetings"

    def self.get_columns
        [
            :date_at_convert,
            :who_requests,
            :reason,
            :assistants
        ]
    end

    def self.get_exporter
        [
            :date_at_convert,
            :who_requests,
            :reason_export,
            :assistants_export
        ]
    end

    def assistants
        return "" if parbudget_assistants.blank?
        text_out = "<ul>"
        parbudget_assistants.each {|a| text_out = text_out + "<li>#{a.try(:full_name)}</li>" }
        text_out = text_out + "</ul>"
        text_out.html_safe
    rescue
        ""
    end

    def date_at_convert
        self.date_at.strftime("%d/%m/%Y")
    rescue
        ""
    end

    def reason_export
        Nokogiri::HTML(reason).text
    rescue
        ""
    end

    def assistants_export
        Nokogiri::HTML(assistants).text
    rescue
        ""
    end
end

