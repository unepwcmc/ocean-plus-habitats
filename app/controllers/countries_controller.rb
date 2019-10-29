class CountriesController < ApplicationController
  def index
  end

  def show
    @country = Country.find(params[:id])

    @yml_key = @country[:iso3].downcase

    habitats = I18n.t('global.habitats')

    habitats_present_data = [
      { status: 'present', status_title: getStatusText('present')},
      { status: 'absent', status_title: getStatusText('absent')},
      { status: 'unknown', status_title: getStatusText('unknown')},
      { status: 'present', status_title: getStatusText('present')},
      { status: 'present', status_title: getStatusText('present')}
    ]

    @habitats_present = habitats.zip(habitats_present_data)
  end

  def getStatusText status
    I18n.t("countries.shared.habitats_present.title_#{status}")
  end
end