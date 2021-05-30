class Parbudget::Responsible < ApplicationRecord
    belongs_to :parbudget_center, class_name: "Parbudget::Center"
    has_many :parbudget_projects, class_name: "Parbudget::Project"

    validates :full_name, :phone, presence: true
    validates_format_of :phone, :with => /\A(\+34|0034|34)?[6|7|8|9][0-9]{8}\z/, allow_blank: true
    validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true

    self.table_name = "parbudget_responsibles"


    def self.get_columns
        [
            :full_name,
            :phone,
            :email,
            :position,
            :center
        ]
    end

    def self.get_exporter
        [
            :full_name,
            :phone,
            :email,
            :position,
            :center
        ]
    end

    def center
        self.try(:parbudget_center).try(:denomination)
    end
   
end

