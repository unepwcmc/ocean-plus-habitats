class Serializers::HabitatCoverSerializer < Serializers::Base

  def initialize
    super(I18n.t('home.habitat_cover.habitats'), 'habitat_cover')
  end

  def serialize
    habitat_cover_array = []

    @habitat_cover.each do |habitat, translations|
      habitat_cover_item = translations

      habitat_global_change = Habitat.find_by(name: habitat.to_s).global_change_stat

      stats = reformat(habitat_global_change)

      habitat_cover_item[:text] =
      I18n.t(
        "home.habitat_cover.habitats.#{habitat}.text",
        change_percentage: stats[:change_percentage],
        baseline_year: stats[:baseline_year],
        recent_year: stats[:recent_year],
        )

      citation = stats[:citations].nil? ? stats[:citation] : interactive_citations(habitat_cover_item, stats[:citations])
      
      if stats[:citations].nil?
        citation_url = '' 
        habitat_cover_item[:modal_content] = citation + citation_url
      end

      habitat_cover_item[:change_percentage] = stats[:change_percentage]
      habitat_cover_item[:id] = habitat

      habitat_cover_array.push(habitat_cover_item)
    end

    habitat_cover_array
  end

  def interactive_citations(item, citations)
    arr = []

    citations.each do |citation|
      
      citation_text = citation[:citation]
      if citation[:citation_url].nil?
        citation_url = I18n.t("home.habitat_cover.no_url")
      else
        link = citation[:citation_url]
        citation_url = "<a target='_' class='modal__link' href='#{link}'>Source</a>"
      end
    
      arr << citation_text + ' ' + citation_url
    end

    item[:modal_content] = "<h3>Sources</h3>" + arr.join("<br><br>")
  end

  def reformat(habitat_global_change)
    if habitat_global_change.nil?
      change_percentage = '-'
      citation = I18n.t('home.habitat_cover.no_citation')
    else
      citations = habitat_global_change.global_change_citations.to_a

      if habitat_global_change[:percentage_lost].nil?
        change_percentage = habitat_global_change[:lower_bound_percentage].round().to_s + ' - ' + habitat_global_change[:upper_bound_percentage].round().to_s + '%'
      else
        change_percentage = habitat_global_change[:percentage_lost].round().to_s + '%'
      end
      baseline_year = habitat_global_change[:baseline_year]
      recent_year = habitat_global_change[:recent_year]
    end

    { change_percentage: change_percentage, baseline_year: baseline_year, recent_year: recent_year,
      citations: citations, citation: citation }
    end
  end
