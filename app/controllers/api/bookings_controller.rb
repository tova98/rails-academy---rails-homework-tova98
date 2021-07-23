module Api
  class BookingsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

    def index
      @bookings = Booking.all

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @booking = Booking.find(params[:id])

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @booking = Booking.new(booking_params)

      if @booking.save
        render json: BookingSerializer.render(@booking, view: :normal, root: :booking),
               status: :created
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    def update
      @booking = Booking.find(params[:id])

      if @booking.update(booking_params)
        render json: BookingSerializer.render(@booking, view: :normal, root: :booking)
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
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

    def rescue_from_not_found
      render json: { errors: ['Booking not found.'] }
    end

    def render_with_serializer(serializer)
      if serializer.blank? || serializer == 'blueprinter'
        render json: BookingSerializer.render(@booking, view: :normal, root: :booking)
      elsif serializer == 'JSON:API'
        render json: { booking: JsonApi::BookingSerializer.new(@booking)
                                                          .serializable_hash[:data][:attributes] }
      end
    end

    def render_with_root(root)
      if root.blank? || root == '1'
        render json: BookingSerializer.render(@bookings, view: :normal, root: :bookings)
      elsif root == '0'
        render json: BookingSerializer.render(@bookings, view: :normal)
      end
    end
  end
end
