module Sensors::Entities
  class SensorValue < Grape::Entity
    expose :id
    expose :value
    expose :time_unix
  end
end
