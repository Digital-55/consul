class CreateParbudgetMedias < ActiveRecord::Migration[5.0]
  def change
    create_table :parbudget_medias do |t|
      t.text :text_document
      t.string :title
      t.belongs_to :parbudget_project, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
