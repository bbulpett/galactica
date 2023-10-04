class AddTriggerForCurrencyConversionUpdate < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TRIGGER currency_rates_after_update
      AFTER UPDATE ON currency_rates
      FOR EACH ROW
      BEGIN
        CALL update_converted_price(NEW.to_currency, NEW.rate);
      END;
    SQL
  end

  def down
    execute 'DROP TRIGGER IF EXISTS currency_rates_after_update;'
  end
end
