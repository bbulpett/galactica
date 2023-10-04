class CurrencyImporter
  RATES_KEY = ENV.fetch('EXCHANGE_RATE_API_KEY').freeze
  RATES_URL = 'http://api.exchangeratesapi.io/v1/latest?base=USD'.freeze
  TO_CURRENCY_SYMBOLS = %w[CAD EUR GBP INR JPY SAR USD].freeze

  def initialize; end

  def run
    update_exchange_rates(exchange_rates_hash)

    # Iterate through all product variants and update their converted prices 🙄
    update_product_variant_prices
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

  def update_product_variant_prices
    ProductVariant.all.each do |product_variant|
      product_variant.update!(
        converted_price: converted_price(product_variant)
      )
    end
  end

  def converted_price(product_variant)
    currency_exchange_rate = exchange_rate(product_variant.currency_label)
    currency_precision = product_variant.currency_label == 'JPY' ? 0 : 2

    return if currency_exchange_rate.nil?

    price = (product_variant.price * currency_exchange_rate).to_f

    price.round(currency_precision)
  end

  def exchange_rate(currency_label)
    return 1 if currency_label == 'USD'

    CurrencyRate.find_by(to_currency: currency_label)&.rate
  end
end
