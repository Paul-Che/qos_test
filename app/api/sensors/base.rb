module Sensors
  class Base < Grape::API

    format :json

    resource :sensors do

      # GET /sensors
      get do
        present :sensors, Sensor.all, with: Sensors::Entities::Sensor
      end


      route_param :sensor_id do

        # GET /sensors/42
        params do
          requires :sensor_id, type: Integer, desc: 'Sensor id'
        end

        get do
          if params[:deleted].present?
            sensor = Sensor.deleted.find(params[:sensor_id])
            present :sensor_id, sensor.id
          else
            sensor = Sensor.find(params[:sensor_id])
            present :sensor, sensor, with: Sensors::Entities::Sensor
          end
          begin
          rescue ActiveRecord::RecordNotFound
            error!({ status: :not_found }, 404)
          end
        end

        # DELETE /sensors/42
        params do
          requires :sensor_id, type: Integer, desc: 'Sensor id'
        end

        delete do
          begin
            sensor = Sensor.find(params[:sensor_id])
            { status: :success } if sensor.destroy
          rescue ActiveRecord::RecordNotFound
            error!({ status: :error, message: :not_found }, 404)
          end
        end

        resource :values do

          # GET /sensors/42/values
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
              error!({ status: :error, message: :not_found }, 404)
            end
          end

          # POST /sensors/42/values
          params do
            requires :time_unix, type: Integer, desc: 'time_unix.'
            requires :value, type: Integer, desc: 'value.'
          end

          post do
            sensor = Sensor.find(params[:sensor_id])
            sensor_value = sensor.values.new(id: params[:id],
                                             time_unix: params[:time_unix],
                                             value: params[:value])
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
        requires :name, type: String, desc: 'Sensor name'
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
