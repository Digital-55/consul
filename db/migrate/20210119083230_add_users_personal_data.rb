class AddUsersPersonalData < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :last_name, :string
    add_column :users, :last_name_alt, :string
  end
end
