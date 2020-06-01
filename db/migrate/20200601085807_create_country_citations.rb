class CreateCountryCitations < ActiveRecord::Migration[5.1]
  def change
    create_table :country_citations do |t|
      t.text :citation, null: false
      t.integer :country_id, null: false
    end
  end
end
