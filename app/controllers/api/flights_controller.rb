module Api
  class FlightsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

    def index
      @flights = Flight.all

      render json: FlightSerializer.render(@flights, root: :flights)
    end

    def show
      @flight = Flight.find(params[:id])
      render json: FlightSerializer.render(@flight, root: :flight)
    end

    def create
      @flight = Flight.new(flight_params)

      if @flight.save
        render json: FlightSerializer.render(@flight, root: :flight), status: :created
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def update
      @flight = Flight.find(params[:id])

      if @flight.update(flight_params)
        render json: FlightSerializer.render(@flight, root: :flight)
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @flight = Flight.find(params[:id])

      if @flight.destroy
        render json: { messages: ['Flight has been deleted.'] }, status: :no_content
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    private

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price,
                                     :departs_at, :arrives_at, :company_id)
    end

    def rescue_from_not_found
      render json: { errors: ['Flight not found.'] }
    end
  end
end
