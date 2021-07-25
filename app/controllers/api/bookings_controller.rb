module Api
  class BookingsController < ApplicationController
    def index
      @bookings = Booking.all
      # authorize @bookings

      @bookings = Booking.all.where(user_id: current_user.id) if current_user.role != 'admin'

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @booking = Booking.find(params[:id])
      token = request.headers['Authorization']
      if User.find_by(token: token).id != @booking.user_id
        render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
      else
        render_with_serializer(request.headers['X_API_SERIALIZER'])
      end
    end

    def create
      token = request.headers['Authorization']
      params['booking']['user_id'] = User.find_by(token: token).id
      @booking = Booking.new(booking_params)
      if @booking.save
        render json: BookingSerializer.render(@booking, root: :booking), status: :created
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    def update # rubocop:disable Metrics/AbcSize
      if params[:booking][:user_id] && current_user.role != 'admin'
        render json: { error: 'Authorization denied' }, status: :unauthorized
      else
        @booking = Booking.find(params[:id])
        if @booking.update(booking_params)
          render json: BookingSerializer.render(@booking, root: :booking)
        else
          render json: { errors: @booking.errors.as_json }, status: :bad_request
        end
      end
    end

    def destroy
      @booking = Booking.find(params[:id])

      if @booking.destroy
        render json: { messages: ['Booking has been deleted.'] }, status: :no_content
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    private

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end
  end
end
