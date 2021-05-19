FactoryBot.define do
    factory :sg_table_order, class: "Sg::TableOrder" do
        table_name "x"
        order "0"  
        association :sg_generic, factory: :sg_generic
    end

    factory :sg_table_field, class: "Sg::TableField" do
        table_name "Hola mundo"
        field_name "created_at"
    end

    factory :sg_setting, class: "Sg::Setting" do
        title "Prueba setting"
        setting_type "select"
    end

    factory :sg_generic, class: "Sg::Generic" do   
        title "prueba"
        generic_type "search"
    end

    factory :sg_select, class: "Sg::Select" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end
end