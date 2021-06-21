class Parbudget::EconomicBudget < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project", foreign_key: "parbudget_project_id"
   

    self.table_name = "parbudget_economic_budgets"

    validates :year, :import, :start_date, presence: true
    validate :check_dates


    private

    def check_dates
        if !self.start_date.blank? && !self.end_date.blank? && self.start_date > self.end_date
            self.errors.add(:start_date, "La fecha de inicio debe ser menor a la fecha de fin")
        end
    end

end

