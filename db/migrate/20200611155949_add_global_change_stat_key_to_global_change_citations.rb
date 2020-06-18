class AddGlobalChangeStatKeyToGlobalChangeCitations < ActiveRecord::Migration[5.1]
  def change
    add_reference :global_change_citations, :global_change_stat
  end
end
