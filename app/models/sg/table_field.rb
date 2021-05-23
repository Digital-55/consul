class Sg::TableField < ApplicationRecord
    belongs_to :sgeneric, :polymorphic => true, touch: true

    self.table_name = "sg_table_fields"

    validates :table_name, :field_name, presence: true
    #validates :table_name, uniqueness: { scope: :field_name }

    validate :unique_field


    private

    def unique_field
        exist = nil
        case self.sgeneric_type.to_s
        when "Sg::Generic"
            exist = ::Sg::TableField.find_by(sgeneric: self.sgeneric, table_name: self.table_name, field_name: self.field_name)
        when "Sg::Setting"
            if self.sgeneric.setting_type.to_s == "search"
                exist = ::Sg::TableField.find_by(sgeneric: self.sgeneric, table_name: self.table_name, field_name: self.field_name)
            else
                exist = ::Sg::TableField.find_by(sgeneric: self.sgeneric, table_name: self.table_name)
            end
        end

        if !exist.blank? && exist.id != self.id
            self.errors.add(:table_name, "Ya existe el elemento")
        end
    end
end
