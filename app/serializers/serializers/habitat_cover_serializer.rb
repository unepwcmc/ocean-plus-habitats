class Serializers::HabitatCoverSerializer < Serializers::Base

  def initialize
    super(I18n.t('home.habitat_cover.habitats'), 'habitat_cover')
  end

  def serialize
    habitat_cover_array = []

    @habitat_cover.each do |habitat, translations|
      habitat_cover_item = translations

      habitat_global_change = Habitat.find_by(name: habitat.to_s).global_change_stat

      sanitised_stats = reformat(habitat_global_change)

      habitat_cover_item[:text] =
      I18n.t(
        "home.habitat_cover.habitats.#{habitat}.text",
        change_percentage: sanitised_stats[:change_percentage],
        baseline_year: sanitised_stats[:baseline_year],
        recent_year: sanitised_stats[:recent_year],
        )

      citation = sanitised_stats[:citations]
  
      unless habitat_global_change.nil? 
        citation = add_links(habitat_cover_item, sanitised_stats[:citations])
      end

      habitat_cover_item[:modal_content] = citation 
      habitat_cover_item[:change_percentage] = sanitised_stats[:change_percentage]
      habitat_cover_item[:change_direction] = I18n.t("global.loss_of")

      habitat_cover_item[:id] = habitat

      habitat_cover_array.push(habitat_cover_item)
    end

    habitat_cover_array
  end

  def add_links(item, citations)
    arr = []

    citations.each do |citation|

      citation_text = citation[:citation]
      if citation[:citation_url].nil?
        citation_url = ''
      else
        link = citation[:citation_url]
        citation_url = "<a target='_' class='modal__link' href='#{link}'>Source</a>"
      end

      arr << citation_text + ' ' + citation_url
    end

    item[:modal_content] = arr
  end

  def reformat(habitat_global_change)
    if habitat_global_change.nil?
      citations = []
      change_percentage = nil
      citations << I18n.t('home.habitat_cover.no_citation')
    else
      citations = habitat_global_change.global_change_citations.to_a

      # Whether to show a range or a single discrete figure
      if habitat_global_change[:percentage_lost].nil?
        lower_bound = habitat_global_change[:lower_bound_percentage].round().to_s
        upper_bound = habitat_global_change[:upper_bound_percentage].round().to_s
        change_percentage = lower_bound + ' - ' + upper_bound + '%'
      else
        percentage_loss = habitat_global_change[:percentage_lost].round().to_s
        change_percentage = percentage_loss + '%'
      end

      baseline_year = habitat_global_change[:baseline_year]
      recent_year = habitat_global_change[:recent_year]
    end

    { change_percentage: change_percentage, baseline_year: baseline_year, recent_year: recent_year,
      citations: citations }
  end
end