class CompaniesQuery
  attr_reader :relation

  def initialize(relation = Company.all)
    @relation = relation
  end

  def sorted
    relation.order(:name)
  end

  def with_active_flights
    relation.select('companies.*')
            .distinct
            .joins(:flights)
            .where('departs_at > ?', DateTime.current)
  end

  def self.all(scope, params)
    @companies = CompaniesQuery.new(scope).sorted

    return @companies unless params['filter'].present? && params['filter'] == 'active'

    @companies = CompaniesQuery.new(@companies).with_active_flights
  end
end
