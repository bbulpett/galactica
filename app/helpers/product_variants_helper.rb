module ProductVariantsHelper
  def variant_last_updated(product_variant)
    product_variant.updated_at.strftime("%e %b %y -- %H:%M:%S %Z")
  end

  def price_for_display(currency:, price:)
    return "NULL" if price.nil?

    currency == 'JPY' ? price.to_i : price
  end

  def list_limit
    100
  end
end
