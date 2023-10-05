class ProductVariantsController < ApplicationController
  def index
    @product_variants = ProductVariant.all
  end
end
