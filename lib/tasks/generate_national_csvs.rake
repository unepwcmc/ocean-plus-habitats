require 'csv'

namespace :generate do
  desc 'Generate CSVs containing data for each habitat for each country'
  
  @list_of_iso3s = GeoEntity.countries.pluck(:iso3).compact
  @habitat_names = Habitat.pluck(:name)
  @required_headers = %w[name total_area protected_area percent_protected presence]
  @mangroves_headers = ChangeStat.first.attributes.except('id', 'habitat_id', 'geo_entity_id', 'created_at', 'updated_at').keys

  task national_csvs: [:environment] do
    habitat_data_directory = 'lib/data/habitat_coverage_protection'
    base_output_directory = 'public/downloads/national'

    generate_csvs(habitat_data_directory, base_output_directory)
  end

  def generate_csvs(dir, base_output_dir)
    # First we combine all of the CSVs together in one array, for easy generation of each CSV
    combined_csvs = @habitat_names.map do |habitat|
      # CSV.read creates an array of arrays
      { data: CSV.read("#{dir}/#{habitat}_country_output.csv", headers: true), habitat: habitat }
    end

    # Separate out mangroves from the rest of the data first
    mangroves_data, combined_csvs = combined_csvs.partition { |data_hash| data_hash[:habitat] == 'mangroves' }

    # Then we find the correct element from each array (via the ISO3), to construct a CSV for each country
    @list_of_iso3s.each do |iso3|
      habitat_data = [combined_csvs, mangroves_data].map do |array|
          array.map do |data_hash|
          row = data_hash[:data].find { |csv_row| csv_row['ISO3'] == iso3 }
          next unless row
          
          # Get rid of unneeded values (row number and ISO3) by converting row to a hash
          parse_required_values_and_convert_to_row(row, data_hash[:habitat])
        end
      end

      output_dir = base_output_dir + "/#{iso3}"

      FileUtils.mkdir_p(output_dir) unless Dir.exist?(output_dir)

      CsvUtils.csv_from_csv_rows(output_dir, @required_headers, habitat_data.first, filename: 'all_other_habitats')
      CsvUtils.csv_from_csv_rows(output_dir, @required_headers, habitat_data.last, filename: 'mangroves')
    end
  end

  def parse_required_values_and_convert_to_row(row, name_of_habitat)
    row_with_name = row.to_hash.merge({ "name" => name_of_habitat })

    required_values = row_with_name.slice(*@required_headers).values

    CSV::Row.new(@required_headers, required_values)
  end
end
