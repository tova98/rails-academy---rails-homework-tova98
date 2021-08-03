module Api
  module Statistics
    class CompaniesController < ApplicationController
      def index
        @companies = authorize Company.includes(:flights).all, :statistics_index?
        render json: ::Statistics::CompanySerializer.render(@companies, root: :companies)
      end

      def policy_class
        ::Statistics::CompanyPolicy
      end
    end
  end
end
