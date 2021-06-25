class Complan::Center < ApplicationRecord
    has_many :complan_people, foreign_key: "complan_center_id", class_name: "Complan::Person", dependent: :destroy
    has_many :complan_imports, foreign_key: "complan_center_id", class_name: "Complan::Import", dependent: :destroy

    self.table_name = "complan_centers"

    def self.get_columns
        [
           :organism,
           :denomination,
           :address,
           :dg,
           :sg
        ]
    end

    def self.get_exporter
        [
            :organism,
            :dg,
            :sg,
            :denomination,
            :address
        ]
    end
   
end

