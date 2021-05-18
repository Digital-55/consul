class ChangeColumnSuresActuationsMultipleYears < ActiveRecord::Migration[5.0]
  def change
    remove_column :sures_actuations, :multi_annos
    add_reference :sures_actuations, :sures_actuations_multi_years, index: true, foreign_key: true
  end
end
