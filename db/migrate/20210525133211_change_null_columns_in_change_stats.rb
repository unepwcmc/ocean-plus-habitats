class ChangeNullColumnsInChangeStats < ActiveRecord::Migration[5.1]
  def change
    change_column_null :change_stats, :total_value_1996, true
    change_column_null :change_stats, :total_value_2007, true
    change_column_null :change_stats, :total_value_2008, true
    change_column_null :change_stats, :total_value_2009, true
    change_column_null :change_stats, :total_value_2010, true
    change_column_null :change_stats, :total_value_2015, true
    change_column_null :change_stats, :total_value_2016, true
    change_column_null :change_stats, :protected_value, true
    change_column_null :change_stats, :protected_percentage, true
  end
end