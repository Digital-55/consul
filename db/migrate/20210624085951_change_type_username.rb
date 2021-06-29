class ChangeTypeUsername < ActiveRecord::Migration[5.0]
  def up
    execute "ALTER TABLE users ALTER COLUMN username TYPE VARCHAR(120) USING SUBSTR(username, 1, 120)"
    change_column :users, :username, :string, limit: 120
  end

  def down
    change_column :users, :username, :string, limit: 60
  end
end
