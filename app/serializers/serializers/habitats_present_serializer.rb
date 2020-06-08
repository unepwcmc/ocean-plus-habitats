class Serializers::HabitatsPresentSerializer < Serializers::Base
  include ApplicationHelper

  def initialize(habitat_presence_statuses, country)
    super(country, 'country')
    super(habitat_presence_statuses, 'habitat_presence_statuses')
  end

  def serialize
    occurrences = base_occurrences.merge(@habitat_presence_statuses)
    habitats.map do |habitat|
      id = habitat[:id]

      habitats_present = habitat.dup
      habitats_present[:status] = occurrences[id]
      habitats_present[:status_title] = get_status_text(habitats_present[:status])

      # Transforming plain text URLs into live links
      source = ['<h3>Sources</h3>']
      if !sources(habitat)[:citation].empty?
        sources(habitat)[:citation].each do |citation|
          source << citation.split.map { |string| string[/^(http)/] ?
             "<a target='_' class='modal__link' href=\"#{sources(habitat)[:url].first}\"> " + string + " </a>" : string
           }.join(' ')
        end
      else
        source << "No citations found."
      end

      # habitats_present[:citation] = sources(habitat)[:citation]
      # @country_yml[:habitats_present_citations][id.to_sym]
      habitats_present[:citation] = source

      habitats_present
    end
  end

  def get_status_text status
    I18n.t("countries.shared.habitats_present.title_#{status}")
  end

  def base_occurrences
    GeoEntityStat::BASE_OCCURRENCES
  end



  def sources(habitat)
    habitat_id = Habitat.find_by_name(habitat[:id]).try(:id)
    ges_id = GeoEntityStat.where(habitat_id: habitat_id, geo_entity_id: @country.id).pluck(:id)
    citation_ids = GeoEntityStatsSources.where(geo_entity_stat_id: ges_id).pluck(:citation_id)
    { url: Source.where(citation_id: citation_ids).pluck(:source_url),
      citation: Source.where(citation_id: citation_ids).pluck(:citation) }
  end
end
