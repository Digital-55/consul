class RenameSuresActuationMultiYears < ActiveRecord::Migration[5.0]
  def change
    rename_table :sures_actuation_multi_years, :actuations_multi_years
  end
end
