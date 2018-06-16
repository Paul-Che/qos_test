module Sensors
  class SensorsAPI < Grape::API

    format :json

    resource :sensors do
      # GET /sensors
      get do
        present Sensor.all, with: Sensors::Entities::Sensor
      end

      # GET /sensors/42
      params do
        requires :id, type: Integer, desc: 'Sensor id'
      end

      get ':id' do
        begin
          Sensor.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          error!({ status: :not_found }, 404)
        end
      end

      # DELETE /sensors/42
      params do
        requires :id, type: Integer, desc: 'Sensor id'
      end

      delete ':id' do
        begin
          sensor = Sensor.find(params[:id])
          { status: :success } if sensor.delete
        rescue ActiveRecord::RecordNotFound
          error!({ status: :error, message: :not_found }, 404)
        end
      end

      # POST /sensors
      params do
        requires :name, type: String, desc: 'Sensor name'
      end

      post do
        begin
          sensor = Sensor.create(name: params[:name])
          if sensor.save
            { sensor: { id: sensor.id, name: sensor.name, values: sensor.values } }
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
