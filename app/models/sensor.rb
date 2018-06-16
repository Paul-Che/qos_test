class Sensor < ApplicationRecord
  soft_deletable

  has_many :deleted_values, -> { where deleted: true }, foreign_key: 'sensor_id',
                                                        class_name: 'SensorValue',
                                                        dependent: :destroy
  has_many :values, foreign_key: 'sensor_id',
                    class_name: 'SensorValue',
                    dependent: :destroy
end
