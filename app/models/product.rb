# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :product_variants
end
