class ChangeColumnsParbudgetProject < ActiveRecord::Migration[5.0]
  def change
    add_column :parbudget_projects, :status, :string
    add_column :parbudget_projects, :web_title, :string
    remove_column :parbudget_projects, :assumes_dgpc
    remove_column :parbudget_projects, :plate_installed

    add_column :parbudget_projects, :plate_installed, :boolean
  end
end
