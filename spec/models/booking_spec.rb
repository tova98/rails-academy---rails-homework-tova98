RSpec.describe Booking do
  it 'is invalid without seat price' do
    booking = described_class.new(seat_price: nil)
    booking.valid?
    expect(booking.errors[:seat_price]).to include("can't be blank")
  end

  it 'is invalid when seat price is less than 0' do
    booking = described_class.new(seat_price: -2)
    booking.valid?
    expect(booking.errors[:seat_price]).to include('must be greater than 0')
  end

  it 'is invalid without number of seats' do
    booking = described_class.new(no_of_seats: nil)
    booking.valid?
    expect(booking.errors[:no_of_seats]).to include("can't be blank")
  end

  it 'is invalid when number of seats is less than 0' do
    booking = described_class.new(no_of_seats: -2)
    booking.valid?
    expect(booking.errors[:no_of_seats]).to include('must be greater than 0')
  end
end
