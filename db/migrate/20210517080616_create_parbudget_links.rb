class CreateParbudgetLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_links do |t|
      t.string :url
      t.belongs_to :project, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
