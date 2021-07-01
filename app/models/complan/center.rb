class Complan::Center < ApplicationRecord
    has_many :complan_people, foreign_key: "complan_center_id", class_name: "Complan::Person", dependent: :destroy
    has_many :complan_imports, foreign_key: "complan_center_id", class_name: "Complan::Import", dependent: :destroy

    accepts_nested_attributes_for :complan_people, allow_destroy: true

    validates_associated :complan_people

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

