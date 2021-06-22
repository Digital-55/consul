class CreateConplanAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :conplan_editors do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end

    create_table :conplan_readers do |t|
      t.belongs_to :user, index: true, foreign_key: true
    end
  end
end
