class AddReferencesComplan < ActiveRecord::Migration[5.0]
  def up
    add_reference :complan_activities, :complan_performance, index: true, foreign_key: true
    add_reference :complan_ambits, :complan_performance, index: true, foreign_key: true
    add_reference :complan_trackings, :complan_performance, index: true, foreign_key: true
    add_reference :complan_projects, :complan_strategy, index: true, foreign_key: true
    add_reference :complan_locations, :complan_financing, index: true, foreign_key: true
    add_reference :complan_performances, :complan_project, index: true, foreign_key: true
    add_reference :complan_performances, :complan_financing, index: true, foreign_key: true
    add_reference :complan_files, :complan_financing, index: true, foreign_key: true
    add_reference :complan_people, :complan_center, index: true, foreign_key: true
    add_reference :complan_assistants, :complan_person, index: true, foreign_key: true
    add_reference :complan_assistants, :complan_thecnical_table, index: true, foreign_key: true
    add_reference :complan_imports, :complan_financing, index: true, foreign_key: true
    add_reference :complan_imports, :complan_center, index: true, foreign_key: true
    add_reference :complan_medias, :complan_performance, index: true, foreign_key: true
    add_reference :complan_beneficiaries, :complan_performance, index: true, foreign_key: true
    add_reference :complan_indicators, :complan_performance, index: true, foreign_key: true
    add_reference :complan_beneficiaries_typologies, :complan_beneficiary, index: {name: 'index_complan_bt_beneficiary'}, foreign_key: true
    add_reference :complan_beneficiaries_typologies, :complan_typology, index: {name: 'index_complan_bt_typology'}, foreign_key: true
    add_reference :complan_thecnical_tables, :complan_performance, index: true, foreign_key: true
    add_reference :complan_credit_modifications, :complan_import, index: true, foreign_key: true
  end

  def down
    remove_reference :complan_activities, :complan_performance
    remove_reference :complan_ambits, :complan_performance
    remove_reference :complan_trackings, :complan_performance
    remove_reference :complan_projects, :complan_strategy
    remove_reference :complan_locations, :complan_financing
    remove_reference :complan_performances, :complan_project
    remove_reference :complan_performances, :complan_financing
    remove_reference :complan_files, :complan_financing
    remove_reference :complan_people, :complan_center
    remove_reference :complan_assistants, :complan_person
    remove_reference :complan_assistants, :complan_thecnical_table
    remove_reference :complan_imports, :complan_financing
    remove_reference :complan_imports, :complan_center
    remove_reference :complan_medias, :complan_performance
    remove_reference :complan_beneficiaries, :complan_performance
    remove_reference :complan_indicators, :complan_performance
    remove_reference :complan_beneficiaries_typologies, :complan_beneficiary
    remove_reference :complan_beneficiaries_typologies, :complan_typology
    remove_reference :complan_thecnical_tables, :complan_performance
    remove_reference :complan_credit_modifications, :complan_import
  end
end
