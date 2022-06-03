# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merchants_data = File.read('./db/seeds/merchants.json')
merchants_json = JSON.parse(merchants_data)
merchants_json['RECORDS'].each do |order|
  Merchant.insert(order.merge({ 'updated_at' => Time.now, 'created_at' => Time.now }))
end

shoppers_data = File.read('./db/seeds/shoppers.json')
shoppers_json = JSON.parse(shoppers_data)
shoppers_json['RECORDS'].each do |order|
  Shopper.insert(order.merge({ 'updated_at' => Time.now, 'created_at' => Time.now }))
end

orders_data = File.read('./db/seeds/orders.json')
orders_json = JSON.parse(orders_data)
orders_json['RECORDS'].each do |order|
  Order.insert(order.merge({ 'updated_at' => Time.now }))
end
