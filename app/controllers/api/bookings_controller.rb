module Api
  class BookingsController < ApplicationController
    def index
      @bookings = policy_scope(Booking)

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @booking = authorize Booking.find(params[:id])

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @booking = Booking.new(permitted_attributes(Booking))
      @booking.user_id = current_user.id if @booking.user_id.nil?

      if @booking.save
        render json: BookingSerializer.render(@booking, root: :booking), status: :created
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    def update
      @booking = authorize Booking.find(params[:id])

      if @booking.update(permitted_attributes(@booking))
        render json: BookingSerializer.render(@booking, root: :booking)
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @booking = authorize Booking.find(params[:id])

      if @booking.destroy
        render json: { messages: ['Booking has been deleted.'] }, status: :no_content
      else
        render json: { errors: @booking.errors.as_json }, status: :bad_request
      end
    end
  end
end
