module Sensors
  class Base < Grape::API

    format :json

    resource :sensors do

      # GET /sensors
      get do
        present :sensors, Sensor.all, with: Sensors::Entities::Sensor
      end


      route_param :sensor_id do

        # GET /sensors/:sensor_id
        params do
          requires :sensor_id, type: Integer
        end

        get do
          if params[:deleted].present?
            sensor = Sensor.deleted.find(params[:sensor_id])
            present :sensor_id, sensor.id
          else
            sensor = Sensor.find(params[:sensor_id])
            present :sensor, sensor, with: Sensors::Entities::Sensor
          end
        end

        # DELETE /sensors/:sensor_id
        params do
          requires :sensor_id, type: Integer
        end

        delete do
          begin
            sensor = Sensor.find(params[:sensor_id])
            { status: :success } if sensor.destroy
          rescue ActiveRecord::RecordNotFound
            error!({ status: :not_found }, 404)
          end
        end

        resource :values do

          # GET /sensors/:sensor_id/values
          get do
            begin
              values = if params[:deleted].present?
                         if Sensor.deleted.empty? || Sensor.deleted.find(params[:sensor_id]).nil?
                           []
                         else
                           Sensor.deleted.find(params[:sensor_id]).deleted_values
                         end
                       else
                         Sensor.find(params[:sensor_id]).values
                       end
              present :values, values, with: Sensors::Entities::SensorValue
            rescue ActiveRecord::RecordNotFound
              error!({ status: :not_found }, 404)
            end
          end

          # POST /sensors/:sensor_id/values
          params do
            requires :time_unix, type: Integer
            requires :value, type: Integer
          end

          post do
            sensor = Sensor.find(params[:sensor_id])
            sensor_value = sensor.values.new(id:        params[:id],
                                             time_unix: params[:time_unix],
                                             value:     params[:value])
            sensor_value.save
            begin
              present :value, sensor_value, with: Sensors::Entities::SensorValue
            rescue ActiveRecord::RecordNotFound
              error!({ status: :not_found }, 404)
            end
          end
        end
      end

      # POST /sensors
      params do
        requires :name, type: String
      end

      post do
        begin
          sensor = Sensor.create(id: params[:id], name: params[:name])
          if sensor.save
            present :sensor, sensor, with: Sensors::Entities::Sensor
          else
            error!(status: :error, message: sensor.errors.full_messages.first) if sensor.errors.any?
          end
        rescue ActiveRecord::RecordNotFound
          error!({ status: :error, message: :not_found }, 404)
        end
      end

    end
  end
end
