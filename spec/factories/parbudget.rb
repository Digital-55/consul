FactoryBot.define do
    factory :parbudget_ambit, :class => 'Parbudget::Ambit' do
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
        #association :parbudget_project, factory: :parbudget_project  
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
        code_old "B014"
        denomination "Proyecto denominado"
        author "Autor 1"
        entity "Entidad 1"
        email "p@p.es"
        phone "614787878"
        association :parbudget_responsible, factory: :parbudget_responsible 
        association :parbudget_ambit, factory: :parbudget_ambit    
        association :parbudget_topic, factory: :parbudget_topic    
    end

    factory :parbudget_responsible, class: "Parbudget::Responsible" do
        full_name "Responsable completo 1"
        phone "614525252"
        association :parbudget_center, factory: :parbudget_center       
    end

    factory :parbudget_topic, class: "Parbudget::Topic" do
       name "Topic 1"      
    end

    factory :parbudget_track_ext, class: "Parbudget::TrackExt" do
        
    end

    factory :parbudget_track_int, class: "Parbudget::TrackInt" do
            
    end

    factory :parbudget_tracking_external, class: "Parbudget::TrackingExternal" do
            
    end

    factory :parbudget_tracking_internal, class: "Parbudget::TrackingInternal" do
           
    end

    factory :parbudget_tracking_meeting, class: "Parbudget::TrackingMeeting" do
            
    end

    factory :parbudget_tracking, class: "Parbudget::Tracking" do
            
    end
end