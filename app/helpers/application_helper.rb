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

  def get_nav_items
    #FERDI - get all countries and then fill out object as follows
    nav_items = {
      countries: [
        {
          title: I18n.t("countries.are.title"),
          url: country_path("ARE")
        },
        {
          title: I18n.t("countries.idn.title"),
          url: country_path("IDN")
        }
      ],
      regions: [
        {
          title: I18n.t("regions.mediterranean.title"),
          url: country_path("mediterranean")
        },
        {
          title: I18n.t("regions.wider_caribbean.title"),
          url: country_path("wider_caribbean")
        }
      ]
    }
  end
  
  def get_habitat_icon_class (habitat, status='')
    status = status == 'present' || status == '' ? '' : "-#{status}"

    "icon--#{habitat}#{status}"
  end
end
