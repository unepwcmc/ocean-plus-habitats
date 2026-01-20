class Serializers::RepresentationHabitatsSerializer < Serializers::Base

  def initialize(country)
    super(country, 'country')
  end

  def serialize
    return {} if @country.iso3.nil?

    set_coastal_and_geo_stats

    @legend = []

    add_habitats_stats_to_legend
    add_multiple_habitats_to_legend
    add_not_covered_to_legend

    {
      legend: @legend,
      chart: {
        coastline_length: ActiveSupport::NumberHelper.number_to_delimited(@coastal_stat.total_coast_length.round),
        theme: "habitats",
      }
    }
  end

  def serialize_for_api
    return {} if @country.iso3.nil?

    set_coastal_and_geo_stats

    @data = []

    add_habitats_stats_to_data
    add_multiple_habitats_to_data
    add_not_covered_to_data

    @data
  end

  private

  def set_coastal_and_geo_stats
    @coastal_stat = CoastalStat.find_by(geo_entity_id: @country)

    @geo_stat = GeoEntityStat.where(geo_entity_id: @country)
  end

  def add_habitats_stats_to_data
    Habitat.all.each do |habitat|
      @data << {
        name: habitat.name,
        coverage: get_habitat_coverage(habitat)
      }
    end
  end

  def add_habitats_stats_to_legend
    Habitat.all.each_with_index do |habitat, idx|
      value = get_habitat_coverage(habitat)

      @legend << {
        id: habitat.name,
        title: habitat.name == 'coralreefs' ? 'Warm-water corals' : habitat.title,
        percent: row(value, @coastal_stat.total_coast_length),
        label: "#{idx + 2}."
      }
    end
  end

  def get_habitat_coverage(habitat)
    habitat_stat = @geo_stat.find_by(habitat_id: habitat)

    habitat_stat.coastal_coverage || 0
  end

  def add_multiple_habitats_to_data
    @data.unshift(
      name: 'multiple',
      coverage: @coastal_stat.multiple_habitat_length
    )
  end

  def add_multiple_habitats_to_legend
    @legend.unshift(
      id: 'multiple',
      title: 'Multiple habitats',
      percent: row(@coastal_stat.multiple_habitat_length, @coastal_stat.total_coast_length),
      label: '3.'
    )
  end

  def add_not_covered_to_data
    total_covered_length = @data.map { |habitat| habitat[:coverage] }.inject(0, :+)
    not_covered_length = @coastal_stat.total_coast_length - total_covered_length

    @data << {
      name: 'notcovered',
      coverage: not_covered_length
    }
  end

  def add_not_covered_to_legend
    percent_value = 100 - @legend.map { |habitat| habitat[:percent] }.inject(0, :+)
    @legend.push(id: 'notcovered', title: 'Not covered', percent: percent_value, label: '6.')
  end

  def row(value, total_length)
    ((value / total_length) * 100).round
  end
end
