class CountriesController < ApplicationController
  def index
  end

  def show
    @country = Country.find(params[:id])

    @yml_key = @country[:iso3].downcase

    habitats = I18n.t('global.habitats')
    habitat_citations = I18n.t("countries.#{@yml_key}.habitats_present_citations")

    habitats_present_data = [
      { status: 'present', status_title: getStatusText('present')},
      { status: 'absent', status_title: getStatusText('absent')},
      { status: 'unknown', status_title: getStatusText('unknown')},
      { status: 'present', status_title: getStatusText('present')},
      { status: 'present', status_title: getStatusText('present')}
    ]

    @habitats_present = habitats.zip(habitats_present_data, habitat_citations)

    @red_list_categories = I18n.t('home.red_list.categories')
    red_list_data = [[1,2,3,4,5,6,7],[],[1,2,3,4,5,6,7],[1,2,3,4,5,6,7],[]]

    @red_list_data = habitats.zip(red_list_data)
  end

  def getStatusText status
    I18n.t("countries.shared.habitats_present.title_#{status}")
  end
end
