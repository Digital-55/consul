class Sg::Setting < ApplicationRecord
    has_many :sg_table_fields, as: :sgeneric, class_name: "Sg::TableField", dependent: :destroy
    has_many :sg_selects, class_name: "Sg::Select", foreign_key: "sg_setting_id", dependent: :destroy

    accepts_nested_attributes_for :sg_table_fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :sg_selects, reject_if: :all_blank, allow_destroy: true

    validates_associated :sg_table_fields
    validates_associated :sg_selects

    self.table_name = "sg_settings"

    scope :search_settings, -> { where(setting_type: "search") }
    scope :order_settings, -> { where(setting_type: "order") }
end
