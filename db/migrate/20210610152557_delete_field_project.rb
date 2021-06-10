class DeleteFieldProject < ActiveRecord::Migration[5.0]
  def change
    remove_reference :parbudget_projects, :parbudget_local_forum
    
  end
end
