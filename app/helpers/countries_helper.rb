module CountriesHelper
  def if_country_get_flag(country_name)
    name = country_name.downcase.gsub(' ', '-')
    flag = FileTest.exist?("app/assets/images/flags/#{name}.svg")

    flag ? image_tag("flags/#{name}.svg", alt: '', class: 'header__icon') : nil
  end

  def nav_tertiary_countries
    I18n.t('countries.nav_sticky').to_json
  end

  def dataset_status(dataset)
    @country.occurrences[dataset[:id]]
  end

  def dataset_status_title(dataset)
    status = dataset_status(dataset) == 'present-but-unknown' ? 'data_deficient' : dataset_status(dataset)

    I18n.t("shared.proportion_protected.title_#{status}")
  end

  def icon_class(dataset)
    status = dataset_status(dataset) == 'present-but-unknown' ? 'present' : dataset_status(dataset)

    get_habitat_icon_class(dataset[:id], status)
  end

  def protected_percentage(dataset)
    if @country.protection_stats[dataset[:id]] 
      protected_percentage = @country.protection_stats[dataset[:id]]['protected_percentage']

      return 0 if protected_percentage.nil?

      protected_percentage.round(2)
    else
      0
    end
  end

  def total_value(dataset)
    @country.protection_stats[dataset[:id]] ? @country.protection_stats[dataset[:id]]['total_value'].round : 0
  end

  def habitat_with_data
    @red_list_data.find { |habitat| habitat['data'].present? }
  end

  def habitats_present_redlist
    if @habitats_present.nil?
      @red_list_data
    else
      @red_list_data.reject { |habitat| @habitats_present.find { |a| a[:id] == habitat[:id] && a[:status] != 'present' } }
    end
  end

  def habitat_status(habitat)
    return 'present' if @habitats_present.nil?
    @habitats_present.find { |hab_present| hab_present[:id] == habitat[:id] }[:status]
  end

  def preferential_selection(species)
    if @example_species_select.find { |habitat| habitat[:id] == 'mangroves'}
      @example_species_selected = @example_species_select.find { |habitat| habitat[:id] == 'mangroves'}.to_json
    elsif @example_species_select.find { |habitat| habitat[:id] == 'seagrasses'}
      @example_species_selected = @example_species_select.find { |habitat| habitat[:id] == 'seagrasses'}.to_json
    else
      @example_species_selected = @example_species_select[0].to_json
    end
  end

  def habitats_representation_modal
    map_to_citations_string(I18n.t('countries.shared.habitat_representation.citations'))
  end

  def country_red_list_modal
    I18n.t('countries.shared.red_list.citations', year: Date.today.year).each do |cit|
      {
        text: cit
      }.to_json
    end
  end

  def habitat_condition_modal
    map_to_citations_string(I18n.t('countries.shared.habitat_condition.citation'))
  end

  def country_habitat_change_modal
    map_to_citations_string(I18n.t('countries.shared.habitat_change.citations'))
  end

  def target_tabs
    target_tabs = I18n.t('countries.shared.targets.tabs')

    target_tabs[2][:list].each do |habitat|
      habitat[:title] = get_habitat_from_id(habitat[:id])[:title]
    end

    target_tabs
  end
end
