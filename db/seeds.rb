# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

CURRENCY_RATE_SEEDS =
  JSON.parse(File.read('data/exchange_rate_seeds.json')).freeze
NUM_PRODUCTS = 10_000
VARIANT_CURRENCY_LABELS =
  (CURRENCY_RATE_SEEDS.pluck('to_currency') + ['USD']).freeze

# Create products
NUM_PRODUCTS.times do
  Product.create!(
    title: Faker::Book.title
  )
end

# Create one product variant per currency for each product
Product.all.each do |product|
  VARIANT_CURRENCY_LABELS.each do |currency_label|
    product.product_variants.create!(
      currency_label:,
      price: Faker::Number.decimal(
        l_digits: rand(1..3),
        r_digits: 2
      ),
      converted_price: nil
    )
  end
end

# Create currency rate record for USD
CurrencyRate.create!(
  from_currency: 'USD',
  to_currency: 'USD',
  rate: 1.00
)

# Create currency rates
CURRENCY_RATE_SEEDS.each do |rate|
  CurrencyRate.create!(
    from_currency: rate['from_currency'],
    to_currency: rate['to_currency'],
    rate: rate['exchange_rate']
  )
end
