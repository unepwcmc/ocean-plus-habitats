module AboutHelper
  def contributors
    [
      {
        id: 'redlist',
        name: t('about.contributors.logos.red_list'),
        url: 'https://www.iucnredlist.org/',
        image: 'redlist'
      },
      {
        id: 'protected-planet',
        name: t('about.contributors.logos.protected_planet'),
        url: 'https://www.protectedplanet.net/',
        image: 'protected-planet'
      }
    ]
  end
end