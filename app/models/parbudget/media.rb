class Parbudget::Media < ApplicationRecord
    belongs_to :parbudget_project, class_name: "Parbudget::Project", foreign_key: "parbudget_project_id"
    

    self.table_name = "parbudget_medias"

   
end

