namespace :search_settings do
  desc "Add new sures search settings dinamic"
  task add: :environment do
    Sures::SearchSetting.delete_all
    ApplicationLogger.new.info "Remove old settings"

    ApplicationLogger.new.info "Adding default settings"

    ApplicationLogger.new.info "Adding sures searchs settings dinamic"

    ApplicationLogger.new.info "Adding searchs order"
    
    Sures::SearchSetting.find_or_create_by(title: 'Por relevancia de la información', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "updated_at", rules: "asc") 
    Sures::SearchSetting.find_or_create_by(title: 'Por estrategia', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "financig_performance", rules: "asc") 
    Sures::SearchSetting.find_or_create_by(title: 'Por actuación', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "actions_taken", rules: "asc") 
    Sures::SearchSetting.find_or_create_by(title: 'Por proyecto', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "project", rules: "asc") 
    Sures::SearchSetting.find_or_create_by(title: 'Por distrito', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "territorial_scope", rules: "asc") 
    #Sures::SearchSetting.find_or_create_by(title: 'Por barrio', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "location_performance", rules: "asc") 
    Sures::SearchSetting.find_or_create_by(title: 'Por estado de ejecución', data_type: 'order', data: nil, resource: "Sures::Actuation", field: "status", rules: "asc")

    ApplicationLogger.new.info "Adding searchs fields"

    boroughts = {}
    Proposal.all.where(comunity_hide: :true).each do |borought|
      boroughts.merge!({"#{borought.title}" => borought.title })
    end

    districts ={}
    Geozone.all.each do |g|
      districts.merge!({g.name => g.id})
    end

    districts_status ={}
    Geozone.all.each do |g|
      districts_status.merge!({g.id.to_s => true})
    end

    strategic = {"planed" => true, "tramit" => true, "ifs" => true, "other" => true}

    exec_status = {"study" => true, "tramit" => true, "process" => true, "fhinish" => true}

    Sures::SearchSetting.find_or_create_by(title: 'Estratégia', data_type: 'select', data: {
      "#{I18n.t("admin.sures.actuations.actuation.financing_planed")}": "planed",
      "#{I18n.t("admin.sures.actuations.actuation.financing_tramit")}": "tramit",
      "#{I18n.t("admin.sures.actuations.actuation.financing_ifs")}": "ifs",
      "#{I18n.t("admin.sures.actuations.actuation.financing_other")}": "other"
    }.to_s.to_json, resource: "Sures::Actuation", field: "financig_performance", rules: nil, data_status: strategic.to_json)
    Sures::SearchSetting.find_or_create_by(title: 'Proyecto', data_type: 'text', data: nil, resource: "Sures::Actuation", field: "actions_taken", rules: nil)
    Sures::SearchSetting.find_or_create_by(title: 'Actuación', data_type: 'text', data: nil, resource: "Sures::Actuation", field: "actions_taken", rules: nil)
    Sures::SearchSetting.find_or_create_by(title: 'Distrito', data_type: 'select', data: districts.to_s.to_json, resource: "Sures::Actuation", field: "geozone_id", rules: nil, data_status: districts_status.to_json)
    #Sures::SearchSetting.find_or_create_by(title: 'Barrio', data_type: 'select', data: boroughts.to_s.to_json, resource: "Sures::Actuation", field: "borought", rules: nil)
    Sures::SearchSetting.find_or_create_by(title: 'Estado de ejecución de la actuación', data_type: 'select', data: {
      "#{I18n.t("admin.sures.actuations.actuation.status_study")}": "study",
      "#{I18n.t("admin.sures.actuations.actuation.status_tramit")}": "tramit",
      "#{I18n.t("admin.sures.actuations.actuation.status_process")}": "process",
      "#{I18n.t("admin.sures.actuations.actuation.status_fhinish")}": "fhinish"
    }.to_s.to_json, resource: "Sures::Actuation", field: "status", rules: nil, data_status: exec_status.to_json)
  end
end
