require 'rails_helper'

RSpec.describe Species, type: :model do
  include_context 'habitats_setup'

  before do
    coralreefs
    coldcorals
    saltmarshes
  end

  describe '#count_species' do
    context 'when species is nil' do
      subject { described_class.count_species(nil) }

      it 'outputs all of the Redlist categories' do
        expect(subject.values.first.length).to eq(8)
        expect(subject.values.first.flatten).to include('CR', 'EN', 'VU', 'NT', 'LC', 'DD', 'NE', 'total')
      end
    end

    context 'when a specific category is requested' do
      before do
        FactoryBot.create_list(:least_concern_species, 5, habitat: coralreefs)
        FactoryBot.create_list(:near_threatened_species, 5, habitat: coralreefs)
        FactoryBot.create_list(:vulnerable_species, 5, habitat: coldcorals)
        FactoryBot.create_list(:endangered_species, 5, habitat: coldcorals)
        FactoryBot.create_list(:critically_endangered_species, 5, habitat: saltmarshes)
      end

      subject { described_class.count_species(Species.all) }

      it 'outputs only the statistic for that category' do
        expect(subject).to eq({
                                'coralreefs' => [['CR', 0], ['EN', 0], ['VU', 0], ['NT', 5], ['LC', 25], ['DD', 0], ['NE', 0], ['total', 30]],
                                'coldcorals' => [['CR', 0], ['EN', 5], ['VU', 5], ['NT', 0], ['LC', 20], ['DD', 0], ['NE', 0], ['total', 30]],
                                'saltmarshes' => [['CR', 5], ['EN', 0], ['VU', 0], ['NT', 0], ['LC', 20], ['DD', 0], ['NE', 0], ['total', 25]]
                              })
      end
    end
  end
end
