class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.integer :citation_id, null: false
      t.text :citation, null: false
      t.text :source_url
    end
  end
end
