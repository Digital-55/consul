class AddAttachMedias < ActiveRecord::Migration[5.0]
  def up
    add_attachment :parbudget_medias, :attachment
  end

  def down
    remove_attachment :parbudget_medias, :attachment
  end
end
