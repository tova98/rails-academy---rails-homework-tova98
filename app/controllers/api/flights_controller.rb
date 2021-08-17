module Api
  class FlightsController < Api::BaseController
    skip_before_action :authenticate, only: [:index, :show]

    def index
      @flights = FlightsQuery.new(Flight.includes(:company).all).sorted
      @flights = FlightsQuery.new(@flights).with_active_flights
      @flights = flights_query

      render_with_root(@flights, request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @flight = Flight.find(params[:id])

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @flight = authorize Flight.new(flight_params)

      if @flight.save
        render json: FlightSerializer.render(@flight, root: :flight),
               status: :created
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def update
      @flight = authorize Flight.find(params[:id])

      if @flight.update(flight_params)
        render json: FlightSerializer.render(@flight, root: :flight)
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @flight = authorize Flight.find(params[:id])

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

    def flights_query
      FlightsQuery.filtered(@flights, params[:name_cont], params[:departs_at_eq],
                            params[:no_of_available_seats_gteq])
    end
  end
end
