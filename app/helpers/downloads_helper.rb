module DownloadsHelper
  DOWNLOAD_LINKS = {
    coldcorals: 'https://wcmc.io/WCMC_001',
    saltmarshes: 'https://wcmc.io/WCMC_027',
    coralreefs: 'https://wcmc.io/WCMC_008',
    seagrasses: 'https://wcmc.io/WCMC_013_014',
    mangroves: 'https://wcmc.io/GMW_001'
  }.freeze

  def spatial_downloads_habitats
    habitats.map do |h|
      {
        id: h[:id],
        name: h[:title],
        url: DOWNLOAD_LINKS[h[:id].to_sym]
      }
    end
  end
end