# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

CURRENCIES = %w[EUR GBP JPY SAR USD]
NUM_PRODUCTS = 5

# Create products
NUM_PRODUCTS.times do
  Product.create!(
    title: Faker::Books::Dune.title
  )
end

# Create one product variant per currency for each product
Product.all.each do |product|
  CURRENCIES.each do |currency|
    product.product_variants.create!(
      currency_label: currency,
      price: Faker::Number.decimal(l_digits: 2),
      converted_price: nil
    )
  end
end
