module ProductVariantsHelper
  def variant_last_updated(product_variant)
    product_variant.updated_at.strftime("%e %b %y -- %l:%M:%S")
  end
end
