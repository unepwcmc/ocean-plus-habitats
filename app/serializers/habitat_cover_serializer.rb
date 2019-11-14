class HabitatCoverSerializer

  def initialize
    @habitat_cover = I18n.t('home.habitat_cover.habitats')
  end

  def serialize
    habitat_cover_array = []
    
    @habitat_cover.each do |habitat, translations| 
      habitat_cover_item = translations
      
      habitat_cover_item[:text] =
        I18n.t(
          "home.habitat_cover.habitats.#{habitat}.text",
          change_km: -80000,
          change_percentage: -8
        )
      habitat_cover_item[:change_percentage] = -8
      habitat_cover_item[:id] = habitat
      habitat_cover_item[:modal_content] = { title: 'hardcoded in serializer', text: habitat_cover_item[:citation] }.to_json

      habitat_cover_array.push(habitat_cover_item)
    end

    habitat_cover_array
  end
end
