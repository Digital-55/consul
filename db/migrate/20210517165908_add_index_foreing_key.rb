class AddIndexForeingKey < ActiveRecord::Migration[5.0]
  def up
    add_reference :parbudget_trackings, :parbudget_project, index: true, foreign_key: true
    add_reference :parbudget_projects, :parbudget_ambit, index: true, foreign_key: true
    add_reference :parbudget_projects, :parbudget_topic, index: true, foreign_key: true
    add_reference :parbudget_projects, :parbudget_responsible, index: true, foreign_key: true
    add_reference :parbudget_projects, :parbudget_local_forum, index: true
    add_reference :parbudget_responsibles, :parbudget_center, index: true, foreign_key: true
  end

  def down
    remove_reference :parbudget_trackings, :parbudget_project
    remove_reference :parbudget_projects, :parbudget_ambit
    remove_reference :parbudget_projects, :parbudget_topic
    remove_reference :parbudget_projects, :parbudget_responsible
    remove_reference :parbudget_projects, :parbudget_local_forum
    remove_reference :parbudget_responsibles, :parbudget_center
  end
end
