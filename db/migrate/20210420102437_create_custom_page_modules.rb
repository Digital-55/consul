class CreateCustomPageModules < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_page_modules do |t|
      t.integer :custom_page_id
      t.string :type
      t.string :subtitle
      t.string :claim

      t.timestamps
    end
    add_index :custom_page_modules, [:type, :custom_page_id]
  end
end
