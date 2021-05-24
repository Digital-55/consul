class AddDataStatusSearchSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :sures_search_settings, :data_status, :string
  end
end
