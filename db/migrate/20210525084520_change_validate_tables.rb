class ChangeValidateTables < ActiveRecord::Migration[5.0]
  def change
    change_column :parbudget_topics, :name, :string, :null => true
    change_column :parbudget_ambits, :name, :string, :null => true
    change_column :parbudget_ambits, :code, :string, :null => true
  end
end
