class Serializers::RepresentationHabitatsSerializer < Serializers::Base

  def initialize(country)
    super(country, 'country')
  end

  def serialize
    return {} if @country.iso3.nil?
    coastal = CoastalStat.find_by(geo_entity_id: @country)
                         .attributes
                         .slice('total_coast_length', 'multiple_habitat_length')
    tot = coastal['total_coast_length']
    hab_stats = GeoEntityStat.where(geo_entity_id: @country)
    legend, rows = [], []
    Habitat.where.not(name: 'coldcorals').each_with_index do |habitat, label|
      stat = hab_stats.find_by(habitat_id: habitat)
      value = stat.try(:coastal_coverage) || 0
      legend << { id: habitat.name, title: habitat.title }
      rows << { percent: ((value / tot) * 100).round, label: "#{label + 2}." }
    end
    legend.unshift(id: 'multiple', title: 'Multiple habitats')
    rows.unshift(percent: ((coastal['multiple_habitat_length'] / tot) * 100).round, label: '1.')
    legend.push(id: 'notcovered', title: 'Not covered')
    rows.push(percent: 100 - rows.map { |row| row[:percent] }.inject(0, :+), label: '6.')
    res = {
      legend: legend,
      chart: {
        chart_title: "% of length of coastline: #{tot.round} km",
        theme: "habitats",
        rows: rows
      }
    }
    res
  end
end
