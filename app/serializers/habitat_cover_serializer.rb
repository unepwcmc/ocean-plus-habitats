class HabitatCoverSerializer

  def initialize
    @habitat_cover = I18n.t('home.habitat_cover.habitats')
  end

  def serialize
    habitat_cover_array = []
    
    @habitat_cover.each do |habitat, translations| 
      habitat_cover_item = translations

      habitat_global_change = Habitat.find_by(name: habitat.to_s).calculate_global_cover_change

      habitat_cover_item[:text] =
        I18n.t(
          "home.habitat_cover.habitats.#{habitat}.text",
          change_km: habitat_global_change[:change_km],
          change_percentage: habitat_global_change[:change_percentage],
          baseline_total: habitat_global_change[:baseline_total]
        )
      habitat_cover_item[:change_percentage] = habitat_global_change[:change_percentage]
      habitat_cover_item[:id] = habitat

      habitat_cover_array.push(habitat_cover_item)
    end

    habitat_cover_array
  end
end
