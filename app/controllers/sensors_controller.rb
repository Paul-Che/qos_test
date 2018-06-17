class SensorsController < ApplicationController

  def index
    @sensors = Sensor.all
  end

  def show
    @sensor = find_sensor
  end

  private

  def find_sensor
    Sensor.find(params[:id])
  end
end
