class Serializers::HabitatCoverSerializer < Serializers::Base

  def initialize
    super(I18n.t('home.habitat_cover.habitats'), 'habitat_cover')
  end

  def serialize
    habitat_cover_array = []

    @habitat_cover.each do |habitat, translations|
      habitat_cover_item = translations

      # habitat_global_change = Habitat.find_by(name: habitat.to_s).calculate_global_cover_change
      habitat_global_change = Habitat.find_by(name: habitat.to_s).global_change_stat

      if habitat_global_change.nil?
        change_percentage = '-'
      else
        citations = habitat_global_change.global_change_citations.to_a.first

        if habitat_global_change[:percentage_lost].nil?
          change_percentage = habitat_global_change[:lower_bound_percentage].round().to_s + ' - ' +
          habitat_global_change[:upper_bound_percentage].round().to_s + '%'
        else
          change_percentage = habitat_global_change[:percentage_lost].round().to_s + '%'
        end
        baseline_year = habitat_global_change[:baseline_year]
        recent_year = habitat_global_change[:recent_year]
      end

      habitat_cover_item[:text] =
        I18n.t(
          "home.habitat_cover.habitats.#{habitat}.text",
          change_percentage: change_percentage,
          baseline_year: baseline_year,
          recent_year: recent_year,
        )

    if habitat_global_change
      citation = I18n.t("home.habitat_cover.habitats.#{habitat}.citation",
        citation: citations[:citation],
        citation_url: citations[:citation_url]
        )
    else
      citation = I18n.t('home.habitat_cover.no_citation')
    end

      habitat_cover_item[:change_percentage] = change_percentage
      habitat_cover_item[:id] = habitat
      habitat_cover_item[:modal_content] = { text: citation }.to_json

      habitat_cover_array.push(habitat_cover_item)
    end

    habitat_cover_array
  end
end
