class Serializers::RepresentationHabitatsSerializer < Serializers::Base

  def initialize(country)
    super(country, 'country')
  end

  def serialize
    return {} if @country.iso3.nil?
    @coastal_stat = CoastalStat.find_by(geo_entity_id: @country)


    @geo_stat = GeoEntityStat.where(geo_entity_id: @country)
    @legend, @rows = [], []

    add_habitats_stats
    add_multiple_habitats
    add_not_covered

    {
      legend: @legend,
      chart: {
        coastline_length: @coastal_stat.total_coast_length.round,
        theme: "habitats",
        rows: @rows
      }
    }
  end

  private

  def add_habitats_stats
    Habitat.all.each_with_index do |habitat, idx|
      habitat_stat = @geo_stat.find_by(habitat_id: habitat)
      value = habitat_stat.coastal_coverage || 0

      @legend << { id: habitat.name, title: habitat.name == 'coralreefs' ? 'Warm-water coral reefs' : habitat.title }
      @rows << row(value, @coastal_stat.total_coast_length, idx)
    end
  end

  def add_multiple_habitats
    @legend.unshift(id: 'multiple', title: 'Multiple habitats')
    @rows.unshift(
      row(
        @coastal_stat.multiple_habitat_length,
        @coastal_stat.total_coast_length,
        1
      )
    )
  end

  def add_not_covered
    @legend.push(id: 'notcovered', title: 'Not covered')
    percent_value = 100 - @rows.map { |row| row[:percent] }.inject(0, :+)
    @rows.push({percent: percent_value , label: '6.'})
  end

  def row(value, total_length, idx)
    {
      percent: ((value / total_length) * 100).round,
      label: "#{idx + 2}."
    }
  end
end
