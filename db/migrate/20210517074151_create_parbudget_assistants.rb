class CreateParbudgetAssistants < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_assistants do |t|
      t.string :full_name
      t.belongs_to :meeting, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
