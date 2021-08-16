module Admin
  class FlightsController < Admin::BaseController
    def index
      @q = Flight.includes(:company).all.page(params[:page]).per(10).ransack(params[:q])
      @flights = @q.result
    end

    def new
      @flight = Flight.new
    end

    def create
      @flight = Flight.new(flight_params)

      if @flight.save
        flash[:success] = 'Flight was successfully created.'
        redirect_to admin_flights_path
      else
        flash[:danger] = 'Flight could not be created.'
        render :new
      end
    end

    def edit
      @flight = Flight.find(params[:id])
    end

    def update
      @flight = Flight.find(params[:id])

      if @flight.update(flight_params)
        flash[:success] = 'Flight was successfully updated.'
        redirect_to admin_flights_path
      else
        flash[:danger] = 'Flight could not be updated.'
        render :edit
      end
    end

    def destroy
      @flight = Flight.find(params[:id])

      @flight.destroy

      flash[:success] = 'Flight was successfully deleted.'
      redirect_to admin_flights_path
    end

    private

    def flight_params
      params.require(:flight).permit(:name, :no_of_seats, :base_price, :company_id,
                                     :departs_at, :arrives_at, :meal_type, :direct)
    end
  end
end
