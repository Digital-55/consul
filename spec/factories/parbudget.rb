FactoryBot.define do
    factory :parbudget_ambit, class: "Parbuget::Ambit" do
        name "Ambito 1"
        code "0"
    end

    factory :parbudget_assistant, class: "Parbudget::Assistant" do
        full_name "Asistente 1"
        association :parbudget_meeting, factory: :parbudget_meeting
    end

    factory :parbudget_center, class: "Parbudget::Center" do
        code "01"
        code_section "02"
        code_program "03"
        denomination "Centro gestor 1"
        association :parbudget_project, factory: :parbudget_project  
    end

    factory :parbudget_economic_budget, class: "Parbudget::EconomicBudget" do   
        association :parbudget_project, factory: :parbudget_project 
    end

    factory :parbudget_link, class: "Parbudget::Link" do
        url "Nueva ruta"
        association :parbudget_project, factory: :parbudget_project
    end

    factory :parbudget_media, class: "Parbudget::Media" do
        association :parbudget_project, factory: :parbudget_project    
    end

    factory :parbudget_meeting, class: "Parbudget::Meeting" do
       date_at Time.zone.now
       who_requests "Raul Perez"
       reason "<p>Razon 1</p>"      
    end

    factory :parbudget_project, class: "Parbudget::Project" do
        year 2015
        code "A0145"
        web_title "Proyecto 1"
        descriptive_memory "<p>Descripción completa</p>"
        votes 50
        cost 15.5
        url "La mia"
        
        association :parbudget_responsible, factory: :parbudget_responsible 
        association :parbudget_ambit, factory: :parbudget_ambit    
        association :parbudget_topic, factory: :parbudget_topic    
    end

    factory :parbudget_responsible, class: "Parbudget::Responsible" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_topic, class: "Parbudget::Topic" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_track_ext, class: "Parbudget::TrackExt" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_track_int, class: "Parbudget::TrackInt" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_tracking_external, class: "Parbudget::TrackingExternal" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_tracking_internal, class: "Parbudget::TrackingInternal" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_tracking_meeting, class: "Parbudget::TrackingMeeting" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end

    factory :parbudget_tracking, class: "Parbudget::Tracking" do
        key "Nueva clave"
        association :sg_setting, factory: :sg_setting      
    end
end