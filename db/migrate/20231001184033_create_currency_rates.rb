class CreateCurrencyRates < ActiveRecord::Migration[7.0]
  def change
    create_table :currency_rates do |t|
      t.string :from_currency
      t.string :to_currency
      t.decimal :rate

      t.timestamps
    end
  end
end
