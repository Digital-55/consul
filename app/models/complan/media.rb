class Complan::Media < ApplicationRecord
    belongs_to :complan_performance, class_name: "Complan::Performance", foreign_key: "complan_performance_id"


    self.table_name = "complan_medias"   
end

