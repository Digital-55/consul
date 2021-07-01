class CreateParbudgetAssistants < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_assistants do |t|
      t.string :full_name, null: false
      t.belongs_to :parbudget_meeting, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
