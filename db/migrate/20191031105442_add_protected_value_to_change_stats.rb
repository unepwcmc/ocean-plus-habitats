class AddProtectedValueToChangeStats < ActiveRecord::Migration[5.1]
  def change
    add_column :change_stats, :protected_value, :decimal, null: false, default: 0
  end
end
