class Sg::TableField < ApplicationRecord
    belongs_to :sgeneric, :polymorphic => true, touch: true

    self.table_name = "sg_table_fields"

    validates :table_name, :field_name, presence: true
    validates :table_name, uniqueness: { scope: :field_name }
end
