class CreateProductVariants < ActiveRecord::Migration[7.0]
  def change
    create_table :product_variants do |t|
      t.string :currency_label
      t.decimal :price
      t.decimal :converted_price
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
