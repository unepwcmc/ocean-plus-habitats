require 'csv'

namespace :generate do
  desc 'Generate CSVs containing data for each habitat for each country'
  
  @list_of_iso3s = GeoEntity.countries.map(&:iso3)
  @habitat_names = Habitat.all.map(&:name)
  @required_headers = %w[name total_area protected_area percent_protected presence]

  task national_csvs: [:environment] do
    habitat_data_directory = 'lib/data/habitat_coverage_protection'
    output_directory = 'public/downloads/national'

    FileUtils.mkdir_p(output_directory) unless Dir.exist?(output_directory)

    generate_csvs(habitat_data_directory, output_directory)
  end

  def generate_csvs(dir, output_dir)
    # First we combine all of the CSVs together in one array, for easy generation of each CSV
    combined_csvs = @habitat_names.map do |habitat|
      # CSV.read creates an array of arrays
      { data: CSV.read("#{dir}/#{habitat}_country_output.csv", headers: true), habitat: habitat }
    end

    # Then we find the correct element from each array (via the ISO3), to construct a CSV for each country
    @list_of_iso3s.each do |iso3|
      habitat_data = combined_csvs.map do |data_hash|
        row = data_hash[:data].find { |csv_row| csv_row['ISO3'] == iso3 }
        next unless row
        
        # Get rid of unneeded values (row number and ISO3) by converting row to a hash
        required_values = parse_required_values(row, data_hash[:habitat])

        # Convert back into a CSV::Row object prior to writing to CSVs
        CSV::Row.new(@required_headers, required_values)
      end

      CsvUtils.csv_from_csv_rows(output_dir, iso3, @required_headers, habitat_data)
    end
  end

  def parse_required_values(row, name_of_habitat)
    row.to_hash.merge({ "name" => name_of_habitat }).slice(*@required_headers).values
  end
end
