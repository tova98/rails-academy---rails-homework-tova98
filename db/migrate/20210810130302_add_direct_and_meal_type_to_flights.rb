class AddDirectAndMealTypeToFlights < ActiveRecord::Migration[6.1]
  def change
    add_column :flights, :direct, :boolean, default: true
    add_column :flights, :meal_type, :string, default: 'no_meal'
  end
end
