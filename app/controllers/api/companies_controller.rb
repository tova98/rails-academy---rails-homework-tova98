module Api
  class CompaniesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found

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

    def rescue_from_not_found
      render json: { errors: ['Company not found.'] }
    end

    def render_with_serializer(serializer)
      if serializer.blank? || serializer == 'blueprinter'
        render json: CompanySerializer.render(@company, root: :company)
      elsif serializer == 'JSON:API'
        render json: { company: JsonApi::CompanySerializer.new(@company)
                                                          .serializable_hash[:data][:attributes] }
      end
    end

    def render_with_root(root)
      if root.blank? || root == '1'
        render json: CompanySerializer.render(@companies, root: :companies)
      elsif root == '0'
        render json: CompanySerializer.render(@companies)
      end
    end
  end
end
