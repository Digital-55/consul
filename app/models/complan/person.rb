class Complan::Person < ApplicationRecord
    belongs_to :complan_center class_name: "Complan::Center", foreign_key: "complan_center_id"
    has_many :complan_assistants, foreign_key: "complan_person_id", class_name: "Complan::Assistant", dependent: :destroy


    self.table_name = "complan_people"   
end

