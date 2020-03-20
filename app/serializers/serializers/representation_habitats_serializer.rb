class Serializers::RepresentationHabitatsSerializer < Serializers::Base

  def initialize(coastal_stat, habitat_stats)
    super(coastal_stat, 'coastal_stat')
    super(habitat_stats, 'habitat_stats')
  end

  def serialize
    coastal = @coastal_stat.attributes.slice('total_coast_length', 'multiple_habitat_length')
    tot = coastal['total_coast_length']
    legend, rows = [], []
    Habitat.where.not(name: 'coldcorals').each_with_index do |habitat, label|
      stat = @habitat_stats.find_by(habitat_id: habitat)
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
