class Parbudget::Project < ApplicationRecord
    belongs_to :parbudget_responsible, class_name: "Parbudget::Responsible"
    belongs_to :parbudget_ambit, class_name: "Parbudget::Ambit"
    belongs_to :parbudget_local_forum, class_name: "Parbudget::Ambit"
    belongs_to :parbudget_topic, class_name: "Parbudget::Topic"
    has_many :parbudget_centers, class_name: "Parbudget::Center"
    has_many :parbudget_trackings, class_name: "Parbudget::Tracking"
    has_many :parbudget_links, class_name: "Parbudget::Link"
    has_many :parbudget_medias, class_name: "Parbudget::Media"
    has_many :parbudget_economic_budgets, class_name: "Parbudget::EconomicBudget"


    self.table_name = "parbudget_projects"
end

