class CreateSuresActuationsMultiYear < ActiveRecord::Migration[5.0]
  def change
    create_table :sures_actuations_multi_years do |t|
      t.string :annos
      t.string :values
    end
  end
end
