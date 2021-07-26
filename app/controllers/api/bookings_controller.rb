module Api
  class BookingsController < ApplicationController
    def index
      @bookings = Booking.all
      authorize @bookings

      @bookings = Booking.all.where(user_id: current_user.id) if current_user.role != 'admin'

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @booking = Booking.find(params[:id])
      authorize @booking

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      attributes = permitted_attributes(Booking.new({ seat_price: params[:booking][:seat_price],
                                                      no_of_seats: params[:booking][:no_of_seats],
                                                      flight_id: params[:booking][:flight_id] }))
      attributes[:user_id] = if current_user.admin?
                               current_user.id || params[:booking][:user_id].presence
                             else
                               current_user.id
                             end

      @booking = Booking.new(attributes)

      if @booking.save
        render json: BookingSerializer.render(@booking, root: :booking), status: :created
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    def update
      @booking = Booking.find(params[:id])
      authorize @booking

      if @booking.update(permitted_attributes(@booking))
        render json: BookingSerializer.render(@booking, root: :booking)
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @booking = Booking.find(params[:id])
      authorize @booking

      if @booking.destroy
        render json: { messages: ['Booking has been deleted.'] }, status: :no_content
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    private

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :flight_id)
    end
  end
end
