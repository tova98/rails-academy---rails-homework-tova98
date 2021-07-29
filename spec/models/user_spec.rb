RSpec.describe User do
  let(:user) { build(:user) }

  it 'is invalid without a first name' do
    user = build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid when first name is shorter than 2 characters' do
    user.first_name = 'A'
    user.valid?
    expect(user.errors[:first_name]).to include('is too short (minimum is 2 characters)')
  end

  it 'is invalid without an email' do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid when email is already taken (case insensitive)' do
    create(:user, first_name: 'User', email: 'user@email.com', password: 'password')
    user.email = 'User@email.com'
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'is invalid when email is in wrong format' do
    user.email = 'user.com'
    user.valid?
    expect(user.errors[:email]).to include('is invalid')
  end
end
