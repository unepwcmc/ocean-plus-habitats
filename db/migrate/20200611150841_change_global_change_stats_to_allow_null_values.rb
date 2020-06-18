class ChangeGlobalChangeStatsToAllowNullValues < ActiveRecord::Migration[5.1]
  def change
    change_column_null :global_change_stats, :percentage_lost, true
    change_column_null :global_change_stats, :lower_bound_percentage, true
    change_column_null :global_change_stats, :upper_bound_percentage, true
  end
end
