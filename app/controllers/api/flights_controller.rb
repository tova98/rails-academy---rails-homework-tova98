module Api
  class FlightsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

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

      if @flight.save
        render json: FlightSerializer.render(@flight, view: :normal, root: :flight),
               status: :created
      else
        render json: { errors: @flight.errors.as_json }, status: :bad_request
      end
    end

    def update
      @flight = Flight.find(params[:id])

      if @flight.update(flight_params)
        render json: FlightSerializer.render(@flight, view: :normal, root: :flight)
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

    def render_with_serializer(serializer)
      if serializer.blank? || serializer == 'blueprinter'
        render json: FlightSerializer.render(@flight, view: :normal, root: :flight)
      elsif serializer == 'JSON:API'
        render json: { flight: JsonApi::FlightSerializer.new(@flight)
                                                        .serializable_hash[:data][:attributes] }
      end
    end

    def render_with_root(root)
      if root.blank? || root == '1'
        render json: FlightSerializer.render(@flights, root: :flights)
      elsif root == '0'
        render json: FlightSerializer.render(@flights)
      end
    end
  end
end
