# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.find_by(id: 1)
unless user
  puts 'Creating an Admin'
  User.create(
    name: 'Admin', email: 'admin@example.com', is_admin: true, roles: 'admin',
    address: 'Galeana #125, col Centro, Guadalajara, Jalisco, México',
    password: 'foobar', password_confirmation: 'foobar',
    phone_number: '000 000 00', cell_phone_number: '00 0000 0000'
  )

  puts 'Creating another user'
  User.create(
    name: 'John', email: 'john@example.com',
    address: 'Bartolomé Gutiérrez #3614',
    password: 'foobar', password_confirmation: 'foobar',
    cell_phone_number: '+52 33 1293 8178', phone_number: '000 000 00'
  )
end

provider = Provider.find_by(id: 1)
unless provider
  puts 'Creating BlackBrocket Provider'
  provider = Provider.create(
    name: 'BlackBrocket', address: 'Galeana #125, col Centro, Guadalajara, Jalisco.',
    phone_number: 'phone goes here', contact: 'We\'re BlackBrocket'
  )
end

provider = Provider.find_by(id: 2)
unless provider
  puts 'Creating generic provider'
  provider = Provider.create(
    name: 'Cafeteros Colombianos', address: 'Galeana #125, col Centro, Bogotá, Colombia.',
    phone_number: '33 33 423 236', contact: 'Juan Ruvalcaba, whats_app: 56-3323-4523'
  )

  puts 'Adding products to the provider'
  provider.products << Product.new(
    name: 'Azucar Refinada', presentation: 'Costal de 30Kg'
  )
  provider.products << Product.new(
    name: 'Splenda', presentation: 'Costal de 30Kg'
  )
  provider.products << Product.new(
    name: 'Miel', presentation: 'Barril de 50 Litros'
  )

  provider.products << Product.new(
    name: 'Leche en polvo', presentation: 'Costal de 50Kg'
  )
  provider.products << Product.new(
    name: 'Cremera', presentation: 'Costal de 50Kg'
  )

  provider.products << Product.new(
    name: 'Fragancia de Vainilla', presentation: 'Envase de 1 Litro'
  )
  provider.products << Product.new(
    name: 'Fragancia de Chocolate', presentation: 'Envase de 1 Litro'
  )
end
