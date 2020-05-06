class Serializers::SpeciesImagesSerializer < Serializers::Base
  def initialize(species, threatened=false)
    super(species, 'species')
    @threatened = threatened
  end

  def serialize
    {
      title: title,
      examples: serialize_species
    }
  end

  private

  def title
    if @threatened
      I18n.t('countries.shared.example_species.example_title_threatened')
    else
      I18n.t('countries.shared.example_species.example_title_common')
    end
  end

  def serialize_species
    species = @threatened ? @species.threatened : @species.most_common
    hash = {}
    species.order_by_category.group_by { |sp| sp.habitat.name }.each do |habitat, _species|
      hash[habitat] = _species.map! { |s| species_hash(s) }.partition{ |species| species[:has_image] }.flatten.first(3)
    end
    hash
  end

  def species_hash(species)
    {
      name_common: species.common_name,
      name_scientific: species.scientific_name,
      image: species_image(species),
      has_image: has_image(species),
      redlist: species.redlist_status,
      redlist_url: species.url
    }
  end

  # TODO Some images seem to be missing - also for the three other habitats aside from mangroves and seagrasses.
  # Probably the ones related to most common species.
  def find_asset_path(species)
    habitat = species.habitat.name
    fallback_image_path = "icons/#{habitat}.svg"
    species_name = species.scientific_name.parameterize.underscore
    asset_path = "species/#{habitat}/#{species_name}_atlas_of_#{habitat}.jpg"
    { habitat: habitat, fallback_image_path: fallback_image_path, species: species_name, asset: asset_path }
  end

  def species_image(species)
    details = find_asset_path(species)
    if has_asset?(details[:asset])
      ActionController::Base.helpers.image_url(details[:asset])
    else
      # Use species name in redlist url to find a possible matching with filename
      # if first attempt with scientific_name fails
      species_name = species.url.split('/').last.gsub('%20', '_').underscore
      path = "species/#{details[:habitat]}/#{species_name}_atlas_of_#{details[:habitat]}.jpg"
      asset_path = has_asset?(path) ? path : details[:fallback_image_path]
      ActionController::Base.helpers.image_url(asset_path)
    end
  end

  def has_image(species)
    details = find_asset_path(species)
    has_asset?(details[:asset]) ? true : false
  end

  def has_asset?(path)
    if Rails.env.development?
      Rails.application.assets.find_asset(path) != nil
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end
