class AddAdreessIdUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :adress, index: true, foreign_key: true
  end
end
