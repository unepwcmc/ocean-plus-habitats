module ApplicationHelper
  def site_title
    'Ocean+ Habitats'
  end

  def site_description
    "Ocean+ Habitats is a living platform providing the world's decision-makers and communities of practice with the best possible global information, knowledge and tools required to manage and conserve ocean ecosystems."
  end

  def title_meta_tag
    if @country && @name
      "#{root_title} | #{@name}"
    elsif current_page?(root_path)
      root_title
    elsif controller.controller_name == 'site'
      site_page_title
    else
      root_title
    end
  end

  def site_page_title
    page_title = t("global.page_title.#{controller.action_name}", default: nil)

    page_title ? "#{root_title} | #{page_title}" : root_title
  end

  def root_title
    t('global.page_title.index')
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
    'Water with wave crests'
  end

  def get_nav_items
    {
      countries: list_of_countries,
      regions: GeoEntity.regions.map { |region| nav_item(region.name) }
    }
  end

  def list_of_countries
    GeoEntity.permitted_countries.sort_by(&:name).map do |country|
      nav_item(country.actual_name)
    end
  end

  def nav_item(name)
    path_name = name
    geo_entity = GeoEntity.find_by_actual_name(name)
    geo_entity_id = geo_entity&.id

    return {} unless geo_entity_id

    {
      id: geo_entity_id,
      name: name,
      url: country_link_path(path_name)
    }
  end

  def get_habitat_icon_class(habitat, status='')
    status = status == 'present' || status == '' ? '' : "-#{status}"

    "icon--#{habitat}#{status}"
  end

  def country_link_path(country_name)
    country = GeoEntity.find_by(actual_name: country_name) || GeoEntity.find_by(name: country_name)

    '/' + country.name.gsub(/ /, '-').downcase
  end

  def country_name_from_param(param_name)
    param_name.gsub('-', ' ').gsub('%27', "'").titleize
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
    map_to_citations_string(I18n.t('home.red_list.citations', year: Date.today.year))
  end

  def eez_map_modal
    map_to_citations_string(I18n.t('home.eez_map.citations'))
  end

  def habitats_present_modal
    map_to_citations_string(I18n.t('countries.shared.habitats_present.citations'))
  end


  def map_to_citations_string(translations)
    citations = ['<p>No citations found.</p>']

    if translations && translations.count.positive?
      citations = translations.map do |cit|
        "<p>#{insert_hyperlinks(cit)}</p>"
      end
    end

    "<h3 class='modal__title'>#{I18n.t('global.sources_modal.title')}</h3>" + citations.join
  end

  def insert_hyperlinks(citation)
    citation.split.map { |string| string[/^(http)/] ?
      "<a target='_' class='modal__link' href='#{string}'>#{string}</a>" : string
    }.join(' ')
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
      placeholder: 'Country or Territory'
    }.to_json
  end

  def get_nav_primary
    [
      {
        title: t('global.page_title.about'),
        url: about_path
      },
      {
        title: t('global.page_title.legal'),
        url: legal_path
      }
    ].to_json
  end
end
