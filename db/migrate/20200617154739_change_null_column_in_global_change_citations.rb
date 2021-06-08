class ChangeNullColumnInGlobalChangeCitations < ActiveRecord::Migration[5.1]
  def change
    change_column_null :global_change_citations, :citation_url, true
  end
end
