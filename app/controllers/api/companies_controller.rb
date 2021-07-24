module Api
  class CompaniesController < ApplicationController
    def index
      @companies = Company.all

      render_with_root(request.headers['X_API_SERIALIZER_ROOT'])
    end

    def show
      @company = Company.find(params[:id])

      render_with_serializer(request.headers['X_API_SERIALIZER'])
    end

    def create
      @company = Company.new(company_params)

      if @company.save
        render json: CompanySerializer.render(@company, root: :company), status: :created
      else
        render json: { errors: @company.errors.as_json }, status: :bad_request
      end
    end

    def update
      @company = Company.find(params[:id])

      if @company.update(company_params)
        render json: CompanySerializer.render(@company, root: :company)
      else
        render json: { errors: @company.errors.as_json }, status: :bad_request
      end
    end

    def destroy
      @company = Company.find(params[:id])

      if @company.destroy
        render json: { messages: ['Company has been deleted.'] }, status: :no_content
      else
        render json: { errors: @company.errors.as_json }, status: :bad_request
      end
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
