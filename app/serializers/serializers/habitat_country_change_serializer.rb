class Serializers::HabitatCountryChangeSerializer < Serializers::Base

  def initialize(country, habitats_presence_data)
    super(country, 'country')
    super(habitats_presence_data, 'habitats_presence_data')
  end

  def serialize
    Habitat.all.map{ |h| get_habitat_change(h) }.compact
  end

  def get_habitat_change habitat
    return nil unless @habitats_presence_data[habitat.name] == 'present'
    
    country_cover_change = habitat.calculate_country_cover_change(@country.name)
    change = {
      id: habitat.name,
      title: habitat.title,
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

    change
  end
end
