class CountriesController < ApplicationController
  def index
  end

  def show
    @country = Country.find(params[:id])

    @yml_key = @country[:iso3].downcase

    country_yml = I18n.t("countries.#{@yml_key}")

    habitat_citations = country_yml[:habitats_present_citations]

    habitats_present_data = [
      { status: 'present', status_title: get_status_text('present')},
      { status: 'absent', status_title: get_status_text('absent')},
      { status: 'unknown', status_title: get_status_text('unknown')},
      { status: 'present', status_title: get_status_text('present')},
      { status: 'present', status_title: get_status_text('present')}
    ]

    @habitats_present = habitats.zip(habitats_present_data, habitat_citations)

    @red_list_categories = I18n.t('home.red_list.categories')
    red_list_data = [[1,2,3,4,5,6,7,28],[],[1,2,3,4,5,6,7,28],[1,2,3,4,5,6,7,28],[]] #FERDI NOTE THE TOTAL AT THE END

    @red_list_data = habitats.zip(red_list_data)

    @target_tabs = I18n.t('countries.shared.targets.tabs')
    @target_text = country_yml[:targets]

    @habitat_change = [
      { 
        id: 'warm-water-coral',
        title: get_habitat_title('warm-water-coral'),
        text: I18n.t('countries.shared.habitat_change.chart_text', km: 20, habitat: get_habitat_title('warm-water-coral'), years: '2000-2019'),
        previous: 80, 
        current: 40 
      },
      { 
        id: 'mangrove', 
        title: get_habitat_title('mangrove'),
        text: I18n.t('countries.shared.habitat_change.chart_text', km: 40, habitat: get_habitat_title('warm-water-coral'), years: '2000-2019'),
        previous: 50, 
        current: 25 
      }
    ].to_json
  end

  private
  def habitats
    I18n.t('global.habitats')
  end

  def get_status_text status
    I18n.t("countries.shared.habitats_present.title_#{status}")
  end

  def get_habitat_title id
    habitat = habitats.select { |habitat| habitat[:id] === id }
    habitat[0][:title]
  end
end
