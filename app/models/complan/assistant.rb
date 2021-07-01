class Complan::Assistant < ApplicationRecord
    belongs_to :complan_person, class_name: "Complan::Person", foreign_key: "complan_person_id"
    belongs_to :complan_thecnical_table, class_name: "Complan::ThecnicalTable", foreign_key: "complan_thecnical_table_id"

    self.table_name = "complan_assistants"   
end

