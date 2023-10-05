class CurrencyImporter
  RATES_KEY = ENV.fetch('EXCHANGE_RATE_API_KEY').freeze
  RATES_URL = 'http://api.exchangeratesapi.io/v1/latest?base=USD'.freeze
  TO_CURRENCY_SYMBOLS = %w[CAD EUR GBP INR JPY SAR USD].freeze

  def initialize; end

  def run
    update_exchange_rates(exchange_rates_hash)

    # BRUTE FORCE APPROACH
    # update_product_variant_prices_iteratively

    # CHAD APPROACH
    # update_product_variant_prices_en_masse

    # GIGCHAD APPROACH
    # Let the database do the work for us by using a trigger

    # TURBOCHAD APPROACH 😎
    # Use a trigger on a stored procedure to update the converted prices

    # ULTRACHAD APPROACH (*️⃣ I don't know/remember how to do this in MySQL)
    # Use a trigger and a materialized view to update the converted prices
  end

  private

  def exchange_rates_hash
    JSON.parse(exchange_rates_api_response.body)['rates']
  end

  def exchange_rates_api_response
    symbols_param = TO_CURRENCY_SYMBOLS.join(',')
    Net::HTTP.get_response(
      URI("#{RATES_URL}&access_key=#{RATES_KEY}&symbols=#{symbols_param}")
    )
  end

  def update_exchange_rates(exchange_rates)
    exchange_rates.each do |currency_label, rate|
      CurrencyRate.where(to_currency: currency_label).update(rate: rate)
    end
  end

  # Iterate through all product variants and update their converted prices 🙄
  def update_product_variant_prices_iteratively
    ProductVariant.all.each do |product_variant|
      product_variant.update!(
        converted_price: converted_price(product_variant)
      )
    end
  end

  # Do a mass SQL update of all product variants and update converted prices 🤩
  def update_product_variant_prices_en_masse
    ActiveRecord::Base.connection.execute(
      "UPDATE product_variants
       SET converted_price = price * (
         SELECT rate FROM currency_rates
         WHERE currency_rates.to_currency = product_variants.currency_label
       ),
         updated_at = NOW();"
    )
  end

  def converted_price(product_variant)
    currency_exchange_rate = exchange_rate(product_variant.currency_label)
    currency_precision = product_variant.currency_label == 'JPY' ? 0 : 2

    return if currency_exchange_rate.nil?

    price = (product_variant.price * currency_exchange_rate).to_f

    price.round(currency_precision)
  end

  def exchange_rate(currency_label)
    return 1.00 if currency_label == 'USD'

    CurrencyRate.find_by(to_currency: currency_label)&.rate
  end
end
