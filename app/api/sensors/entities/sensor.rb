module Sensors::Entities
  class Sensor < Grape::Entity
    expose :id
    expose :name
    expose :values, using: Sensors::Entities::SensorValue
  end
end
