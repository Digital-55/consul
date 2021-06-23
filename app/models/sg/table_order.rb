class Sg::TableOrder < ApplicationRecord
    belongs_to :sg_generic, class_name: "Sg::Generic", touch: true

    self.table_name = "sg_table_orders"

    validates :table_name, presence: true
    validates :table_name, uniqueness: true
    validates :order, numericality: { greater_than_or_equal_to: 0 }
end
