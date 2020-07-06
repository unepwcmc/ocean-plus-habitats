module ApplicationHelper
  def site_title
    'The first authoritative online resource on marine habitats'
  end

  def site_description
    'Ocean+ Habitats is an evolving tool that provides insight into the known extent, protection and other statistics of ecologically and economically important ocean habitats, such as corals, mangroves, seagrasses and saltmarshes.'
  end

  def title_meta_tag
    "Ocean+ Habitats"
  end

  def url_encode text
    ERB::Util.url_encode(text)
  end

  def encoded_home_url
    url_encode(request.base_url)
  end

  def social_image
    image_url('social.png')
  end

  def social_image_alt
    'Guanaco Torres del Paine Chile Gregoire Dubois'
  end

  COUNTRIES = %w(indonesia united_arab_emirates argentina australia kenya norway ireland).freeze
  REGIONS = %w(mediterranean wider_caribbean).freeze
  def get_nav_items
    #FERDI - get all countries and then fill out object as follows
    {
      countries: COUNTRIES.map { |c| nav_item(c) },
      regions: REGIONS.map { |r| nav_item(r) }
    }
  end

  def nav_item(item)
    geo_entity_name = item.humanize.split(' ').map(&:capitalize).join(' ')
    geo_entity_id = GeoEntity.find_by_name(geo_entity_name)&.id
    return {} unless geo_entity_id
    {
      id: geo_entity_id,
      name: I18n.t("countries.#{item}.title"),
      url: country_path(geo_entity_name)
    }
  end

  def get_habitat_icon_class(habitat, status='')
    status = status == 'present' || status == '' ? '' : "-#{status}"

    "icon--#{habitat}#{status}"
  end

  def country_path(country)
    '/' + country.gsub(/ /, '-').gsub("'", '%27').downcase
  end

  def country_name_from_param(param_name)
    param_name.gsub('-', ' ').gsub('%27', "'").titleize
  end

  def footer_citation
    if params[:name]
      return t(
        'global.footer_citation.region',
        region: country_name_from_param(params[:name]),
        year: Date.today.year,
        month: Date.today.strftime('%B')
      ).html_safe
    end

    t('global.footer_citation.global').html_safe
  end

  def nav_tertiary
    I18n.t('home.nav_sticky').to_json
  end

  def red_list_categories
    I18n.t('home.red_list.categories')
  end

  def habitat_cover_modal
    map_to_citations_string(I18n.t('home.habitat_cover.citations'))
  end

  def habitat_change_modal(habitat_citations)
    map_to_citations_string(habitat_citations)
  end

  def habitats_protected_modal
    map_to_citations_string(I18n.t('countries.shared.proportion_protected.citations'))
  end

  def red_list_modal
   citations = I18n.t('home.red_list.citations', year: Date.today.year).map do |cit|
      "<p>#{cit}</p>"
    end

    citations.join
  end

  def habitats_present_modal
    map_to_citations_string(I18n.t('countries.shared.habitats_present.citations'))
  end


  def map_to_citations_string translations
    citations = translations.map do |cit|
      "<p>#{cit}</p>"
    end

    "<h3>#{I18n.t('global.sources_modal_title')}</h3>" + citations.join
  end

  def habitat_text(habitat)
    habitat[:change_percentage].nil? ? I18n.t('home.habitat_cover.data_deficient') : habitat[:text].html_safe
  end

  def habitats
    I18n.t('global.habitats')
  end

  def get_habitat_from_id(id)
    habitats.select{ |h| h[:id] == id }[0]
  end

  def habitat_protection(name)
    Habitat.find_by(name: name).calculate_global_protection
  end

  def get_countries_search_config
    {
      id: 'country',
      label: I18n.t('global.main_menu.search_by_country')
    }.to_json
  end
end
