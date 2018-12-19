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
end
