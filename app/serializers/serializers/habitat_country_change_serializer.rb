class Serializers::HabitatCountryChangeSerializer < Serializers::Base

  def initialize(country, habitats_presence_data)
    super(country, 'country')
    super(habitats_presence_data, 'habitats_presence_data')
  end

  def serialize
    Habitat.all.map{ |h| get_habitat_change(h) }.compact
  end

  def get_habitat_change habitat
    status = @habitats_presence_data[habitat.name]

    if status == 'absent'
      cover_change = 0
      text = I18n.t('countries.shared.habitat_change.chart_text_confirmed_absence')
    elsif status == 'unknown'
      cover_change = 0
      text = I18n.t('countries.shared.habitat_change.chart_text_presence_unknown')
    else
      country_cover_change = habitat.calculate_country_cover_change(@country.name)
      cover_change = country_cover_change[:change_percentage]
      text = I18n.t('countries.shared.habitat_change.chart_text_not_available')
    end

    change = {
        id: habitat.name,
        title: habitat.title,
        status: status,
        change: cover_change,
        change_abs: get_change_abs(cover_change),
        change_direction: I18n.t("global.#{cover_change > 0 ? 'gain_of' : 'loss_of'}"),
        text: text
      }

    if status == 'present'
      unless change[:change] == 0
          change[:is_available] = true
          change[:text] = I18n.t('countries.shared.habitat_change.chart_text',
            km: country_cover_change[:change_km],
            habitat: habitat.title,
            years: '2010-2020'
          )
      end
    end

    change
  end

  def get_change_abs(cover_change)
    cover_change.zero? ? '--' : cover_change.abs.to_s.concat('%')
  end
end

