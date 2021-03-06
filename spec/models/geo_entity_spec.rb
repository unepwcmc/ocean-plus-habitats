require 'rails_helper'

RSpec.describe GeoEntity, type: :model do
  include_context 'geo_entity_stat_setup'

  before do
    habitats.each do |habitat|
      countries.each do |country|
        FactoryBot.create(:geo_entity_stat, habitat: habitat, geo_entity: country)
      end
    end
  end

  let(:geo_entity) { GeoEntity.last }

  describe '#count_species' do
    it 'calls the relevant method on the Species model' do
      all_species = geo_entity.all_species

      expect(Species).to receive(:count_species).with(all_species)

      geo_entity.count_species
    end
  end

  describe '#determine_occurrence_attrs' do
    context 'when there are just the standard occurrence statuses present' do
      it 'outputs an array of occurrences for each habitat' do
        expect(geo_entity.determine_correct_occurrences.length).to eq(5)
        expect(geo_entity.determine_correct_occurrences).to all(include('occurrence'))
      end
    end

    context 'when there is are present habitats with an unknown level of protection' do
      it 'changes the occurrence of the relevant habitat' do
        data_deficient_country = FactoryBot.create(:data_deficient_country)

        expect(data_deficient_country.determine_correct_occurrences).to include(
          { 'name' => 'coralreefs', 'occurrence' => 'present-but-unknown' }
        )
      end
    end
  end

  describe '#occurrences' do
    let(:correct_occurrences) do
      [
        { 'name' => 'coralreefs', 'occurrence' => 'absent' },
        { 'name' => 'saltmarshes', 'occurrence' => 'present' },
        { 'name' => 'mangroves', 'occurrence' => 'absent' },
        { 'name' => 'seagrasses', 'occurrence' => 'present' },
        { 'name' => 'coldcorals', 'occurrence' => 'present-but-unknown' }
      ]
    end

    it 'outputs a hash of the occurrences' do
      allow(geo_entity).to receive(:determine_correct_occurrences).and_return(correct_occurrences)

      expect(geo_entity.occurrences).to eq({
                                             'coralreefs' => 'absent',
                                             'saltmarshes' => 'present',
                                             'mangroves' => 'absent',
                                             'seagrasses' => 'present',
                                             'coldcorals' => 'present-but-unknown'
                                           })
    end
  end

  describe '#protection_stats' do
    it 'output a hash of protection statistics' do
      expect(geo_entity.protection_stats.keys).to contain_exactly('coldcorals', 'coralreefs', 'mangroves', 'saltmarshes', 'seagrasses') 
      expect(geo_entity.protection_stats.values).to all( include('protected_percentage', 'protected_value', 'total_value') )
    end
  end
end
