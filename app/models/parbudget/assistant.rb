class Parbudget::Assistant < ApplicationRecord
    belongs_to :parbudget_meeting, class_name: "Parbudget::Meeting", foreign_key: "parbudget_meeting_id"

    

    self.table_name = "parbudget_assistants"

   
end

