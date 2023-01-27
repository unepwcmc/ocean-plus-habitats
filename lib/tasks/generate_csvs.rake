require 'csv'
require 'zip'

namespace :generate do
  desc 'Generate CSVs containing data for each habitat for each country'

  task national_csvs: [:environment] do
    @list_of_iso3s = GeoEntity.countries.pluck(:iso3).compact
    @habitat_names = Habitat.pluck(:name)
    @required_headers = %w[name total_area protected_area percent_protected presence]
    @mangroves_headers = %w[total_area_1996 total_area_2008 total_area_2009 
      total_area_2010baseline total_area_2015 total_area_2016 total_area_2017
      total_area_2018 total_area_2019 total_area_2020
      protected_area percent_protected presence]

    habitat_data_directory = 'lib/data/countries'
    @base_output_directory = "#{Rails.root}/public/downloads/national"

    if Dir.exist?(@base_output_directory) && !Dir.empty?(@base_output_directory)
      FileUtils.rm_rf(@base_output_directory) 
    end

    generate_csvs(habitat_data_directory)
  end

  def generate_csvs(dir)
    # First we combine all of the CSVs together in one array, for easy generation of each CSV
    combined_csvs = @habitat_names.map do |habitat|
      # CSV.read creates an array of arrays
      { 
        data: CSV.read("#{dir}/#{habitat}.csv", headers: true), 
        habitat: habitat 
      }
    end

    FileUtils.mkdir_p(@base_output_directory)

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

      create_zip_from_files(iso3, habitat_data)
    end
  end

  def create_zip_from_files(iso3, habitat_data)
    zipfile_name = File.join(@base_output_directory, iso3 + ".zip")

    unless File.exist?(zipfile_name)
      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        zipfile.add('all_other_habitats', create_all_other_habitats_csv(habitat_data.first))
        zipfile.add('mangroves', create_mangroves_csv(habitat_data.last))  
      end
    end
  end

  def create_all_other_habitats_csv(data)
    CsvUtils.create_temp_csv("all_other_habitats") do |csv|
      CsvUtils.csv_from_csv_rows(csv, @required_headers, data)
    end
  end

  def create_mangroves_csv(data)
    CsvUtils.create_temp_csv("mangroves") do |csv|
      CsvUtils.csv_from_csv_rows(csv, @mangroves_headers, data)
    end
  end

  def parse_required_values_and_convert_to_row(row, name_of_habitat)
    if name_of_habitat == 'mangroves'
      required_values = row.to_hash.slice(*@mangroves_headers).values

      CSV::Row.new(@mangroves_headers, required_values)
    else
      row_with_name = row.to_hash.merge({ 'name' => name_of_habitat })
      required_values = row_with_name.slice(*@required_headers).values

      CSV::Row.new(@required_headers, required_values)
    end
  end
end
