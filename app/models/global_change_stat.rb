class GlobalChangeStat < ApplicationRecord
  belongs_to :habitat
  has_many :global_change_citations, dependent: :destroy
end
