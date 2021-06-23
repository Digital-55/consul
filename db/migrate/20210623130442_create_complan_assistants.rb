class CreateComplanAssistants < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_assistants do |t|

      #reference tehcnical_table
      #reference person

      t.timestamps null: false
    end
  end
end
