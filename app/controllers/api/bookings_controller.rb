module Api
  class BookingsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

    def index
      @bookings = Booking.all

      render json: BookingSerializer.render(@bookings, root: :bookings)
    end

    def show
      @booking = Booking.find(params[:id])
      render json: BookingSerializer.render(@booking, root: :booking)
    end

    def create
      @booking = Booking.new(booking_params)

      if @booking.save
        render json: BookingSerializer.render(@booking, root: :booking), status: :created
      else
        render json: { errors: @booking.errors.full_messages }, status: :bad_request
      end
    end

    def update
      @booking = Booking.find(params[:id])

      if @booking.update(booking_params)
        render json: BookingSerializer.render(@booking, root: :booking)
      else
        render json: { errors: @booking.errors.full_messages }, status: :bad_request
      end
    end

    def destroy
      @booking = Booking.find(params[:id])
      render json: { errors: @booking.errors.full_messages } if @booking.nil?

      if @booking.destroy
        render json: { messages: ['Booking has been deleted.'] }
      else
        render json: { errors: @booking.errors.full_messages }
      end
    end

    private

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end

    def rescue_from_not_found
      render json: { errors: ['Booking not found.'] }
    end
  end
end
