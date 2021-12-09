# frozen_string_literal: true

module RedlistSpeciesLastUpdated
  FILEPATH = 'tmp/.redlist_species_last_updated'

  def self.touched_at
    File.mtime(Rails.root.join(FILEPATH))
  rescue StandardError => _e
    '2021-10-01' # last known update date before this quick and dirty automation
  end

  def self.touch!
    File.write(Rails.root.join(FILEPATH), '')
  end
end
