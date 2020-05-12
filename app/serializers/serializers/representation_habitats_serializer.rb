class Serializers::RepresentationHabitatsSerializer < Serializers::Base

  def initialize(country)
    super(country, 'country')
  end

  def serialize
    return {} if @country.iso3.nil?
    @coastal_stat = CoastalStat.find_by(geo_entity_id: @country)


    @geo_stat = GeoEntityStat.where(geo_entity_id: @country)
    @legend = []


    add_habitats_stats
    add_multiple_habitats
    add_not_covered

    {
      legend: @legend,
      chart: {
        coastline_length: @coastal_stat.total_coast_length.round,
        theme: "habitats"
      }
    }
  end

  private

  def add_habitats_stats
    Habitat.all.each_with_index do |habitat, idx|
      habitat_stat = @geo_stat.find_by(habitat_id: habitat)
      value = habitat_stat.coastal_coverage || 0

      @legend << {
        id: habitat.name,
        title: habitat.name == 'coralreefs' ? 'Warm-water coral reefs' : habitat.title,
        percent: row(value, @coastal_stat.total_coast_length),
        label: "#{idx + 2}."
      }
    end
  end

  def add_multiple_habitats
    @legend.unshift(
      id: 'multiple',
      title: 'Multiple habitats',
      percent: row(@coastal_stat.multiple_habitat_length, @coastal_stat.total_coast_length),
      label: '3.'
    )
  end

  def add_not_covered
    percent_value = 100 - @legend.map { |habitat| habitat[:percent] }.inject(0, :+)
    @legend.push(id: 'notcovered', title: 'Not covered', percent: percent_value, label: '6.')
  end

  def row(value, total_length)
    ((value / total_length) * 100).round
  end
end
