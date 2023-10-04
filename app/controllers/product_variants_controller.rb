class ProductVariantsController < ApplicationController
  def index
    @product_variants = ProductVariant.all.sort_by(&:updated_at)
  end
end
