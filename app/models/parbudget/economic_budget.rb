class Parbudget::EconomicBudget < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project"
   

    self.table_name = "parbudget_economic_budgets"

   
end

