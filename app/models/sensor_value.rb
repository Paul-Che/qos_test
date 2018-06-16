class SensorValue < ApplicationRecord
  soft_deletable
  belongs_to :sensor
end
