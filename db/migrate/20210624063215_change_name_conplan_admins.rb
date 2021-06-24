class ChangeNameConplanAdmins < ActiveRecord::Migration[5.0]
  def change
    rename_table :conplan_editors, :complan_editors
    rename_table :conplan_readers, :complan_readers
  end
end
