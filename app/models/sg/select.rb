class Sg::Select < ApplicationRecord
    belongs_to :sg_setting, class_name: "Sg::Setting", touch: true

    self.table_name = "sg_selects"
end
