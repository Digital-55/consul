class Parbudget::Media < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project"
    

    self.table_name = "parbudget_medias"

   
end

