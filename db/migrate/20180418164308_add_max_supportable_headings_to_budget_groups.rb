class AddMaxSupportableHeadingsToBudgetGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :budget_groups, :max_supportable_headings, :integer, default: 1
  end
end
