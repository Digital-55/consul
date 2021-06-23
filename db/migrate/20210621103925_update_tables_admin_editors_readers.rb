class UpdateTablesAdminEditorsReaders < ActiveRecord::Migration[5.0]
  def change
    rename_table :admin_editors, :budgets_editors
    rename_table :admin_readers, :budgets_readers
  end
end
