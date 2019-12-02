class Serializers::HabitatCountryChangeSerializer < Serializers::Base

  def initialize(country)
    super(country, 'country')
  end

  def serialize
    habitat_change = []
    Habitat.all.each do |habitat|
      country_cover_change = habitat.calculate_country_cover_change(@country.iso3)

      change = {
        id: habitat.name,
        title: get_habitat_title(habitat.name),
        text: I18n.t('countries.shared.habitat_change.chart_text', km: country_cover_change[:change_km], habitat: get_habitat_title(habitat.name), years: '2000-2019'),
        change: country_cover_change[:change_percentage]
      }

      habitat_change << change unless country_cover_change[:change_km] == 0

    end

    habitat_change
  end

  def get_habitat_title name
    Habitat.find_by(name: name).title
  end
end
