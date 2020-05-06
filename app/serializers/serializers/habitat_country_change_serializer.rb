class Serializers::HabitatCountryChangeSerializer < Serializers::Base

  def initialize(country, habitats_presence_data)
    super(country, 'country')
    super(habitats_presence_data, 'habitats_presence_data')
  end

  def serialize
    Habitat.all.map{ |h| get_habitat_change(h) }.compact
  end

  def get_habitat_change habitat
    # return nil unless @habitats_presence_data[habitat.name] == 'present'
    if @habitats_presence_data[habitat.name] == 'absent'
      change = {
        id: habitat.name,
        title: habitat.title,
        status: @habitats_presence_data[habitat.name],
        change: 0,
        text: 'Confirmed absence'
      }
      return change
    elsif @habitats_presence_data[habitat.name] == 'unknown'
      change = {
        id: habitat.name,
        title: habitat.title,
        status: @habitats_presence_data[habitat.name],
        change: 0,
        text: 'Unknown presence'
      }
      return change
    else
      country_cover_change = habitat.calculate_country_cover_change(@country.name)
      change = {
        id: habitat.name,
        title: habitat.title,
        status: @habitats_presence_data[habitat.name],
        change: country_cover_change[:change_percentage],
        text: I18n.t('countries.shared.habitat_change.chart_text_not_available')
      }

      unless change[:change] == 0
        change[:is_available] = true
        change[:text] = I18n.t('countries.shared.habitat_change.chart_text',
          km: country_cover_change[:change_km],
          habitat: habitat.title,
          years: '2000-2019'
        )
      end
      return change
    end

  end
end
