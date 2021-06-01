require 'csv'

module CsvUtils 
  extend self

  # Creates a CSV from an array of CSV::Row objects
  def csv_from_csv_rows(output_directory, filename, headers, csv_row_array)
    CSV.open("#{output_directory}/#{filename}.csv", 'wb') do |csv|
      csv << headers
      
      csv_row_array.each { |row| csv << row }
    end
  end
end