class ActuationsMultiYear < ApplicationRecord
    belongs_to :sures_actuations, foreign_key: "sures_actuations_id"

    
end