class AddProtectedPercentageToChangeStats < ActiveRecord::Migration[5.1]
  def change
    add_column :change_stats, :protected_percentage, :decimal, null: false, default: 0
  end
end
