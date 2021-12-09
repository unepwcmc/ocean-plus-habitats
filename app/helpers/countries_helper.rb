module CountriesHelper
  def if_country_get_flag(country_iso3)
    return unless country_iso3

    flag = FileTest.exist?("app/assets/images/flags/#{country_iso3.downcase}.svg")

    flag ? image_tag("flags/#{country_iso3.downcase}.svg", alt: '', class: 'icon--flag') : nil
  end

  def nav_tertiary_countries
    I18n.t('countries.nav_sticky').to_json
  end

  def dataset_status(dataset)
    @country.occurrences[dataset[:id]]
  end

  def dataset_status_title(dataset)
    # Here, we want the status to read 'Data Deficient'
    status = dataset_status(dataset) 
    status = status == 'present-but-unknown' ? 'unknown' : status

    I18n.t("shared.proportion_protected.title_#{status}")
  end

  def icon_class(dataset)
    # Here, we want to show the icon for the individual habitat as present, in the data class
    status = dataset_status(dataset)
    status = status == 'present-but-unknown' ? 'present' : status

    get_habitat_icon_class(dataset[:id], status)
  end

  def protected_percentage(dataset)
    protection_stats = @country.protection_stats[dataset[:id]] 

    if protection_stats.present?
      protected_percentage = protection_stats['protected_percentage']

      protected_percentage.nil? ? 0 : protected_percentage.round(2)
    else
      0
    end
  end

  def habitat_with_data
    @red_list_data.find { |habitat| habitat['data'].present? }
  end

  def absent_or_unknown(status)
    GeoEntity::NEGATIVE_OCCURRENCE_STATUSES.include?(status)
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
    map_to_citations_string(I18n.t('countries.shared.red_list.citations', year: Date.today.year))
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
