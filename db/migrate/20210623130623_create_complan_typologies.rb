class CreateComplanTypologies < ActiveRecord::Migration[5.0]
  def change
    create_table :complan_typologies do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
