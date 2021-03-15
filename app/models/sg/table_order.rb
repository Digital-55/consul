class Sg::TableOrder < ApplicationRecord
    belongs_to :sg_generic, class_name: "Sg::Generic", touch: true

    self.table_name = "sg_table_orders"
end
