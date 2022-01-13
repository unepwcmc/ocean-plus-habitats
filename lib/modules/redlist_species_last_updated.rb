# frozen_string_literal: true

module RedlistSpeciesLastUpdated
  TIMESTAMP_FILEPATH = 'tmp/.redlist_species_last_updated'

  def self.touched_at
    path = Rails.root.join(TIMESTAMP_FILEPATH)

    if File.exist?(path)
      File.mtime(path)
    else
      '2021-10-01' # last known update date before this quick and dirty automation
    end
  end

  def self.touch!
    File.write(Rails.root.join(TIMESTAMP_FILEPATH), '')
  end
end
