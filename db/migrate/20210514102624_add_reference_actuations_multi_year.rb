class AddReferenceActuationsMultiYear < ActiveRecord::Migration[5.0]
  def change
    add_reference :sures_actuations, :sures_actuations_multi_year, index: true, foreign_key: true
  end
end
