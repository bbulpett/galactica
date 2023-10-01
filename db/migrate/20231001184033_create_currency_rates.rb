class CreateCurrencyRates < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_rates do |t|
      t.string :from_currency
      t.string :to_currency
      t.decimal :rate, precision: 10, scale: 4

      t.timestamps
    end
  end
end
