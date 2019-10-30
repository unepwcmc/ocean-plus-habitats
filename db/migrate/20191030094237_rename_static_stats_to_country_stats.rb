class RenameStaticStatsToCountryStats < ActiveRecord::Migration[5.1]
  def change
    rename_table :static_stats, :country_stats
  end
end
