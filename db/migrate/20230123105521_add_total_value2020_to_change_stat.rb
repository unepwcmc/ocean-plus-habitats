class AddTotalValue2020ToChangeStat < ActiveRecord::Migration[5.1]
  def change
    add_column :change_stats, :total_value_2020, :decimal, default: 0
  end
end
