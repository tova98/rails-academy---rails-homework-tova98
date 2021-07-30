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
            .joins(:flights)
            .where('departs_at > ?', DateTime.current)
  end
end
