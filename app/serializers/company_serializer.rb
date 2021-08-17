class CompanySerializer < Blueprinter::Base
  identifier :id

  fields :name, :created_at, :updated_at
  field :no_of_active_flights do |company|
    company.flights.active.count
  end
end
