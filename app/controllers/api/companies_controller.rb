module Api
  class CompaniesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

    def index
      @companies = Company.all

      render json: CompanySerializer.render(@companies, root: :companies)
    end

    def show
      @company = Company.find(params[:id])
      render json: CompanySerializer.render(@company, root: :company)
    end

    def create
      @company = Company.new(company_params)

      if @company.save
        render json: CompanySerializer.render(@company, root: :company), status: :created
      else
        render json: { errors: @company.errors.full_messages }, status: :bad_request
      end
    end

    def update
      @company = Company.find(params[:id])

      if @company.update(company_params)
        render json: CompanySerializer.render(@company, root: :company)
      else
        render json: { errors: @company.errors.full_messages }, status: :bad_request
      end
    end

    def destroy
      @company = Company.find(params[:id])

      if @company.destroy
        render json: { messages: ['Company has been deleted.'] }
      else
        render json: { errors: @company.errors.full_messages }
      end
    end

    private

    def company_params
      params.require(:company).permit(:name)
    end

    def rescue_from_not_found
      render json: { errors: ['Company not found.'] }
    end
  end
end
