class UserSerializer < Blueprinter::Base
  identifier :id

  fields :first_name, :last_name, :email, :role, :created_at, :updated_at
end
