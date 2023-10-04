class CreateUpdateConvertedPriceProcedure < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE PROCEDURE update_converted_price(
        IN new_currency_label VARCHAR(255),
        IN new_conversion_rate DECIMAL(10, 2)
      )
      
      BEGIN
        UPDATE product_variants
        SET converted_price = price * new_conversion_rate,
            updated_at = NOW()
        WHERE currency_label = new_currency_label;
      END;
    SQL
  end

  def down
    execute 'DROP PROCEDURE IF EXISTS update_converted_price;'
  end
end
  