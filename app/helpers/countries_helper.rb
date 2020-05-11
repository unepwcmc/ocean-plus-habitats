module CountriesHelper
  def if_country_get_flag yml_key
    country = I18n.exists?("countries.#{yml_key}.image_flag")
    flag = FileTest.exist?("app/assets/images/#{t("countries.#{yml_key}.image_flag")}")

    country && flag ? image_tag(I18n.t("countries.#{yml_key}.image_flag"), alt: '', class: 'header__icon') : nil
  end

  def nav_tertiary_countries
    I18n.t('countries.nav_sticky').to_json
  end

  def country_red_list_modal
    {
      title: 'Title hardcoded in controller',
      text: I18n.t('countries.shared.red_list.citation')
    }.to_json
  end

  def dataset_status(dataset)
    dataset_status = @country.occurrences[dataset[:id]]
  end

  def dataset_status_title(dataset)
    dataset_status_title = I18n.t("countries.shared.proportion_protected.title_#{dataset_status(dataset)}")
  end

  def icon_class(dataset)
    icon_class = get_habitat_icon_class(dataset[:id], dataset_status(dataset))
  end

  def protected_percentage(dataset)
    protected_percentage = @country.protection_stats[dataset[:id]] ? @country.protection_stats[dataset[:id]]['protected_percentage'].round(2) : 0
  end

  def total_value(dataset)
    total_value = @country.protection_stats[dataset[:id]] ? @country.protection_stats[dataset[:id]]['total_value'].to_i : 0
  end

  def total_units(dataset)
    # total_units = dataset[:id] == 'coldcorals' ? 'observations' : 'km<sup>2</sup>'.html_safe
    'km<sup>2</sup>'.html_safe if total_units = dataset[:id] == 'coldcorals'
  end

  def habitats_present_modal
    {
      title: 'Hardcoded title in controller',
      text: I18n.t('countries.shared.habitats_present.citation')
    }.to_json
  end

  def habitat_condition_modal
    {
      title: 'Title hardcoded in controller',
      text: I18n.t('countries.shared.habitat_condition.citation')
    }.to_json
  end

  def country_habitat_change_modal
    {
      title: 'Title hardcoded in controller',
      text: I18n.t('countries.shared.habitat_change.citation')
    }.to_json
  end

  def target_tabs
    target_tabs = I18n.t('countries.shared.targets.tabs')

    target_tabs[2][:list].each do |habitat|
      habitat[:title] = get_habitat_from_id(habitat[:id])[:title]
    end

    target_tabs
  end
end
