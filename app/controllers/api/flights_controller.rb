module Api
  class FlightsController < ApplicationController
    skip_before_action :authenticate

    def index
      @flights = Flight.all

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @flight = Flight.find(params[:id])

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @flight = Flight.new(flight_params)
      authorize @flight

      if @flight.save
        render json: FlightSerializer.render(@flight, root: :flight),
               status: :created
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def update
      @flight = Flight.find(params[:id])
      authorize @flight

      if @flight.update(flight_params)
        render json: FlightSerializer.render(@flight, root: :flight)
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @flight = Flight.find(params[:id])
      authorize @flight

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
  end
end
