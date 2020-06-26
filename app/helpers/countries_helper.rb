module CountriesHelper
  def if_country_get_flag yml_key
    country = I18n.exists?("countries.#{yml_key}.image_flag")
    flag = FileTest.exist?("app/assets/images/#{t("countries.#{yml_key}.image_flag")}")

    country && flag ? image_tag(I18n.t("countries.#{yml_key}.image_flag"), alt: '', class: 'header__icon') : nil
  end

  def nav_tertiary_countries
    I18n.t('countries.nav_sticky').to_json
  end

  def dataset_status(dataset)
    dataset_status = @country.occurrences[dataset[:id]]
  end

  def dataset_status_title(dataset)
    dataset_status_title = I18n.t("shared.proportion_protected.title_#{dataset_status(dataset)}")
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
