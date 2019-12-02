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
    species = @threatened ? @species.threatened_and_near.limit(3) : @species.not_threatened.limit(3)
    species.group_by { |sp| sp.habitat.name }.each do |_, _species|
      _species.map! { |s| species_hash(s) }
    end
  end

  def species_hash(species)
    {
      name_common: species.common_name,
      name_scientific: species.scientific_name,
      image: species_image(species),
      redlist: species.redlist_status,
      redlist_url: species.url
    }
  end

  # TODO Some images seem to be missing.
  # Probably the ones related to most common species.
  FALLBACK_IMAGE_PATH = 'species/species.png'.freeze
  def species_image(species)
    habitat = species.habitat.name
    species_name = species.scientific_name.parameterize.underscore
    asset_path = "species/#{habitat}/#{species_name}_atlas_of_#{habitat}.jpg"
    if has_asset?(asset_path)
      ActionController::Base.helpers.image_url(asset_path)
    else
      # Use species name in redlist url to find a possible matching with filename
      # if first attempt with scientific_name fails
      species_name = species.url.split('/').last.gsub('%20', '_').underscore
      path = "species/#{habitat}/#{species_name}_atlas_of_#{habitat}.jpg"
      asset_path = has_asset?(path) ? path : FALLBACK_IMAGE_PATH
      ActionController::Base.helpers.image_url(asset_path)
    end
  end

  def has_asset?(path)
    if Rails.env.development?
      Rails.application.assets.find_asset(path) != nil
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  end
end
