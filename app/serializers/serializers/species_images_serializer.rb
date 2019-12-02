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
      image: ActionController::Base.helpers.image_url('species/species.png'),
      redlist: species.redlist_status,
      redlist_url: species.url
    }
  end
end
