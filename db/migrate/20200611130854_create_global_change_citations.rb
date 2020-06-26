class CreateGlobalChangeCitations < ActiveRecord::Migration[5.1]
  def change
    create_table :global_change_citations do |t|
      t.text :citation, null: false
      t.text :citation_url, null: false
    end
  end
end
