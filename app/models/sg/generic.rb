class Sg::Generic < ApplicationRecord
    has_many :sg_table_fields, as: :sgeneric, class_name: "Sg::TableField", dependent: :destroy
    has_many :sg_table_orders, -> { order(order: :asc)}, class_name: "Sg::TableOrder",foreign_key: "sg_generic_id", dependent: :destroy

    accepts_nested_attributes_for :sg_table_fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :sg_table_orders, reject_if: :all_blank, allow_destroy: true

    validates_associated :sg_table_fields
    validates_associated :sg_table_orders
    validates :title, :generic_type, presence: true

    scope :search_type, -> { where(generic_type: "search") }
    scope :order_type, -> { where(generic_type: "order") }

    self.table_name = "sg_generics"

    def self.search_settings
        generic = Sg::Generic.search_type.first        
        ::Sg::Generic.create(title: "Buscador general", generic_type: "search") if generic.blank?        
        generic
    end

    def self.order_settings
        generic = Sg::Generic.order_type.first        
        ::Sg::Generic.create!(title: "Orden de apartados", generic_type: "order") if generic.blank?        
        generic
    end
end
