class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :currency_label
      t.decimal :price
      t.decimal :converted_price

      t.timestamps
    end
  end
end
