class ChangeVoterIdForVoterHash < ActiveRecord::Migration[4.2]
  def change
    remove_column :nvotes, :voter_id
    add_column :nvotes, :voter_hash, :string
  end
end
