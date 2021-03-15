class Sg::TableField < ApplicationRecord
    belongs_to :sgeneric, :polymorphic => true, touch: true

    self.table_name = "sg_table_fields"
end
