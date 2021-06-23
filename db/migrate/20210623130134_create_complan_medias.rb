class CreateComplanMedias < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_medias do |t|
      t.text :text_document
      t.string :title
      t.string :origin
      t.date :date_document
      #reference performance

      t.timestamps null: false
    end
  end
end
