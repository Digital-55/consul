class ChangeGeozoneActuations < ActiveRecord::Migration[5.0]
  def change
    remove_column :sures_actuations, :geozone_id
    add_column :sures_actuations, :geozones, :jsonb, null: false
    add_index  :sures_actuations, :geozones, using: :gin
    add_column :sures_actuations, :project, :string
    add_column :sures_actuations, :multi_annos, :jsonb, null: false
    add_index  :sures_actuations, :multi_annos, using: :gin
  end
end
