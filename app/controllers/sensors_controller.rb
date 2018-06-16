class SensorsController < ApplicationController

  def index
    @sensors = Sensor.all
  end

  def show
    @sensor = find_sensor
  end

  def new
    @sensor = Sensor.new
  end

  def create
    @sensor = Sensor.new(sensor_params)
    if @sensor.save
      flash[:notice] = 'Sensor added!'
      redirect_to root_path
    else
      flash[:error] = 'Failed to edit sensor!'
      render :new
    end
  end

  def destroy
    @sensor = Sensor.find(params[:id])
    if @sensor.destroy
      flash[:notice] = 'Sensor deleted!'
      redirect_to root_path
    else
      flash[:error] = 'Failed to delete this sensor!'
      render :destroy
    end
  end

  private

  def find_sensor
    Sensor.find(params[:id])
  end

  def sensor_params
    params.require(:sensor).permit(:name)
  end
end
