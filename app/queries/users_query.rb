class UsersQuery
  attr_reader :relation

  def initialize(relation = Company.all)
    @relation = relation
  end

  def sorted
    relation.order(:email)
  end

  def with_query(query)
    relation.where('first_name ILIKE :query OR last_name ILIKE :query OR email ILIKE :query',
                   query: "%#{query}%")
  end
end
