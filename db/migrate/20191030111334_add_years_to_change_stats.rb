class AddYearsToChangeStats < ActiveRecord::Migration[5.1]
  def change
    add_column :change_stats, :total_value_1996, :decimal, null: false, default: 0
    add_column :change_stats, :total_value_2016, :decimal, null: false, default: 0
  end
end
