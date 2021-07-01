class ChangeNameBudgetsAdmins < ActiveRecord::Migration[5.0]
  def change
    rename_table :budgets_editors, :parbudget_editors
    rename_table :budgets_readers, :parbudget_readers
  end
end
