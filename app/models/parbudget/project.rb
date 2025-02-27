class Parbudget::Project < ApplicationRecord
    belongs_to :parbudget_responsible, class_name: "Parbudget::Responsible" , foreign_key: "parbudget_responsible_id"
    belongs_to :parbudget_ambit, class_name: "Parbudget::Ambit", foreign_key: "parbudget_ambit_id"
    belongs_to :parbudget_topic, class_name: "Parbudget::Topic", foreign_key: "parbudget_topic_id"
    has_many :parbudget_centers, class_name: "Parbudget::Center", foreign_key: "parbudget_project_id"
    has_many :parbudget_trackings, class_name: "Parbudget::Tracking", foreign_key: "parbudget_project_id", dependent: :destroy
    has_many :parbudget_links, class_name: "Parbudget::Link", foreign_key: "parbudget_project_id", dependent: :destroy
    has_many :parbudget_medias, class_name: "Parbudget::Media", foreign_key: "parbudget_project_id", dependent: :destroy
    has_many :parbudget_economic_budgets, class_name: "Parbudget::EconomicBudget", foreign_key: "parbudget_project_id", dependent: :destroy

    accepts_nested_attributes_for :parbudget_centers, allow_destroy: true
    accepts_nested_attributes_for :parbudget_trackings, allow_destroy: true
    accepts_nested_attributes_for :parbudget_links, allow_destroy: true
    accepts_nested_attributes_for :parbudget_medias, allow_destroy: true
    accepts_nested_attributes_for :parbudget_economic_budgets, allow_destroy: true

    validates :year, :code, :parbudget_ambit, :web_title, :descriptive_memory, :votes, :cost, :url, :code_old, :denomination, :author, :entity, :email, :phone, presence: true
    validates_format_of :phone, :with => /\A(\+34|0034|34)?[6|7|8|9][0-9]{8}\z/, allow_blank: true
    validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true

    validates_associated :parbudget_links
    validates_associated :parbudget_medias
    validates_associated :parbudget_economic_budgets

    self.table_name = "parbudget_projects"

    def self.get_columns
        [
            :code,
            :year,
            :denomination,
            :responsible,
            :author,
            :votes
        ]
    end

    def self.get_exporter
        [
            :code,
            :year,
            :denomination,
            :responsible,
            :status,
            :author,
            :email,
            :phone,
            :url,
            :descriptive_memory_export,
            :entity,
            :plate_proceeds_translate,
            :license_plate_translate,
            :plate_installed_translate,
            :code_old,
            :votes,
            :cost,
            :ambit,
            :topic
        ]
    end

    def plate_proceeds_translate
        I18n.t(plate_proceeds.to_s)
    end

    def license_plate_translate
        I18n.t(license_plate.to_s)
    end

    def plate_installed_translate
        I18n.t(plate_installed.to_s)
    end

    def responsible
        self.try(:parbudget_responsible).try(:full_name)
    end

    def ambit
        self.try(:parbudget_ambit).try(:name)
    end

    def topic
        self.try(:parbudget_topic).try(:name)
    end

    def descriptive_memory_export
        Nokogiri::HTML(descriptive_memory).text
    rescue
        ""
    end
end

