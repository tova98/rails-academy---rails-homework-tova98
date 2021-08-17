class CompaniesQuery
  attr_reader :relation

  def self.all(scope, params)
    sorted_records = new(scope).sorted

    return sorted_records unless params['filter'].present? && params['filter'] == 'active'

    new(sorted_records).with_active_flights
  end

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
end
