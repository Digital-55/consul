class AddReferenceSuresActuations < ActiveRecord::Migration[5.0]
  def change
    remove_column :sures_actuations, :sures_actuations_multi_years_id
    add_reference :sures_actuations_multi_years, :sures_actuations, index: true, foreign_key: true
  end
end
