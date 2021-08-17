module Admin
  class CompaniesController < Admin::BaseController
    def index
      @q = Company.all.page(params[:page]).per(10).ransack(params[:q])
      @companies = @q.result
    end

    def new
      @company = Company.new
    end

    def create
      @company = Company.new(company_params)

      if @company.save
        flash[:success] = 'Company was successfully created.'
        redirect_to admin_companies_path
      else
        flash[:danger] = 'Company could not be created.'
        render :new
      end
    end

    def edit
      @company = Company.find(params[:id])
    end

    def update
      @company = Company.find(params[:id])

      if @company.update(company_params)
        flash[:success] = 'Company was successfully updated.'
        redirect_to admin_companies_path
      else
        flash[:danger] = 'Company could not be updated.'
        render :edit
      end
    end

    def destroy
      @company = Company.find(params[:id])

      @company.destroy

      flash[:success] = 'Company was successfully deleted.'
      redirect_to admin_companies_path
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
