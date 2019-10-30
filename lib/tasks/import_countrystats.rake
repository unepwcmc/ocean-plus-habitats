require 'csv'

namespace :import do
  desc "import CSV data into database"
  task :countrystats, [:csv_file] => [:environment] do

    habitats = Habitat.all
    @global_coverage = {}

    habitats.each do |habitat|
      csv_file = "#{habitat.name.capitalize}_Protected.csv"
      Rails.logger.info "import CSV: #{csv_file}"
      import_country_csv_file(habitat.name, csv_file)

      csv_file = "#{habitat.name.capitalize}_Total.csv"
      Rails.logger.info "import CSV: #{csv_file}"
      import_country_csv_file(habitat.name, csv_file)

      habitat.update_attributes(global_coverage: @global_coverage[habitat.name])
    end

    Rails.logger.info "recalculate protected percentages"
    recalculate_protected_percentages

    Rails.logger.info "recalculate total habitat percentage with protected area"
    recalculate_total_habitat_percentage_within_protected_area

  end

  def import_country_csv_file(habitat, csv_file)
    filename = "#{Rails.root}/lib/data/#{csv_file}"

    csv = File.open(filename, encoding: "utf-8")
    csv_headers = File.readlines(csv).first.split(",")

    staticstats_hash = {
      iso3: csv_headers[0],
      value: csv_headers[1].chomp
    }

    CSV.parse(csv, headers: true, encoding: "utf-8") do |row|
      csv_staticstats_row = row.to_hash
      iso3 = ""
      value = 0

      staticstats_hash.keys.each do |key|
        if key == :iso3
          iso3 = csv_staticstats_row[staticstats_hash[key]]&.strip
        elsif key == :value
          value = csv_staticstats_row[staticstats_hash[key]]&.strip
        end
      end

      if csv_file.include? "Protected"
        insert_country_stat("protected", habitat, iso3, value)
      elsif csv_file.include? "Total"
        insert_country_stat("total", habitat, iso3, value)
      end
    end

    csv.close

  end

  def insert_country_stat(kind, habitat, iso3, value)
    Rails.logger.info "insert #{kind} value into habitat #{habitat}: #{value} into iso3: #{iso3}"

    case kind
    when "protected"
      update_statistic(iso3, habitat, kind, value)
    when "total"
      @global_coverage[habitat] ||= 0
      @global_coverage[habitat] += value.to_f

      update_statistic(iso3, habitat, kind, value)
    end
  end

  def update_statistic(iso3, habitat_name, kind, value)
    return if ((iso3.include? '/') || (iso3.include? 'ABNJ'))

    country = Country.find_by(iso3: iso3)
    habitat = Habitat.find_by(name: habitat_name)

    if country.nil? || habitat.nil?
      Rails.logger.info "Cannot import #{kind} value into habitat #{habitat_name}: #{value} into iso3: #{iso3}"
      return
    end
    country_stat = CountryStat.find_or_create_by(country_id: country.id, habitat_id: habitat.id)
    country_stat.send("#{kind}_value=", value)
    unless country_stat.save!
      Rails.logger.info "Cannot import #{kind} value into habitat #{habitat_name}: #{value} into iso3: #{iso3}"
    end
  end

  def recalculate_protected_percentages
    CountryStat.all.each do |stat|
      stat.protected_percentage = 100 * (stat.protected_value / stat.total_value)
      stat.save!
    end
  end

  def recalculate_total_habitat_percentage_within_protected_area
    Habitat.all.each do |habitat|
      habitat_total_area = CountryStat.where(habitat: habitat).pluck(:total_value).sum
      habitat_total_protected_area = CountryStat.where(habitat: habitat).pluck(:protected_value).sum

      habitat.protected_percentage = 100 * (habitat_total_protected_area / habitat_total_area)
      habitat.save!
    end
  end

end
