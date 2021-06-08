require 'csv'

module CsvUtils 
  extend self

  # Adds to a CSV object from an array of CSV::Row objects
  def csv_from_csv_rows(csv, headers, csv_row_array)
    csv << headers

    csv_row_array.each { |row| csv << row }
  end

  # Create a temp CSV which can accept a block and returns it for further processing
  def create_temp_csv(filename = '', &block)
    tempfile = Tempfile.new([filename, ".csv"])

    CSV.open(tempfile, 'wb') { |csv| yield(csv) if block_given? }

    tempfile
  end
end