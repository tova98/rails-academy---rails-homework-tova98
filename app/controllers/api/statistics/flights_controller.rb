module Api
  module Statistics
    class FlightsController < Api::BaseController
      def index
        @flights = authorize Flight.includes(:bookings).all, :statistics_index?
        render json: ::Statistics::FlightSerializer.render(@flights, root: :flights)
      end
    end
  end
end
