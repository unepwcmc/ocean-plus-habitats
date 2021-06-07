module AboutHelper
  def contributors
    [
      {
        id: 'redlist',
        name: t('about.contributors.logos.red_list'),
        url: 'https://www.iucnredlist.org/',
        image: 'redlist.svg'
      },
      {
        id: 'protected-planet',
        name: t('about.contributors.logos.protected_planet'),
        url: 'https://www.protectedplanet.net/',
        image: 'protected-planet.svg'
      },
      {
        id: 'global-mangrove-watch',
        name: t('about.contributors.logos.global_mangrove_watch'),
        url: 'https://www.globalmangrovewatch.org/',
        image: 'global-mangrove-watch.png'
      }
    ]
  end
end