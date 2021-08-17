module Api
  module Statistics
    class CompaniesController < Api::BaseController
      def index
        @companies = authorize Company.includes(:flights).all, :statistics_index?
        render json: ::Statistics::CompanySerializer.render(@companies, root: :companies)
      end
    end
  end
end
