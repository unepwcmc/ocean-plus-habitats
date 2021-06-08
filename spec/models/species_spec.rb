require 'rails_helper'

RSpec.describe Species, type: :model do
  include_context 'habitats_setup'

  before do
    coralreefs
    coldcorals
    saltmarshes

    FactoryBot.create_list(:least_concern_species, 5, habitat: coralreefs)
    FactoryBot.create_list(:near_threatened_species, 5, habitat: coralreefs)
    FactoryBot.create_list(:vulnerable_species, 5, habitat: coldcorals)
    FactoryBot.create_list(:endangered_species, 5, habitat: coldcorals)
    FactoryBot.create_list(:critically_endangered_species, 5, habitat: saltmarshes)
  end

  describe '#count_species' do
    context 'when all species are requested' do
      subject { described_class.count_species }

      it 'outputs the full set of results' do
        expect(subject).to eq({
          'coralreefs' => [['CR', 0], ['EN', 0], ['VU', 0], ['NT', 5], ['LC', 25], ['DD', 0], ['NE', 0], ['total', 30]],
          'coldcorals' => [['CR', 0], ['EN', 5], ['VU', 5], ['NT', 0], ['LC', 20], ['DD', 0], ['NE', 0], ['total', 30]],
          'saltmarshes' => [['CR', 5], ['EN', 0], ['VU', 0], ['NT', 0], ['LC', 20], ['DD', 0], ['NE', 0], ['total', 25]]
        })
      end
    end

    context 'when a specific set of species is requested' do
      subject { described_class.count_species(Species.take(5)) }

      it 'outputs only the statistic for that group of species' do
        expect(subject.values.length).to eq(1)
        expect(subject.values.first.last).to eq(['total', 5])
      end
    end
  end
end
