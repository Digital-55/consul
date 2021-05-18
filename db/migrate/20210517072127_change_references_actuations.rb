class ChangeReferencesActuations < ActiveRecord::Migration[5.0]
  def change
    rename_table :sures_actuations_multi_years, :sures_actuation_multi_years
    remove_column :sures_actuations, :sures_actuations_multi_year_id
    remove_column :sures_actuation_multi_years, :sures_actuations_id
    add_reference :sures_actuation_multi_years, :sures_actuations, index: true, foreign_key: true
  end
end
