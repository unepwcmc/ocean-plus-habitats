class HabitatsSerializer

  def initialize(habitat, chart_greatest_coverage, chart_protected_areas, global)
    @habitat = habitat
    @chart_greatest_coverage = chart_greatest_coverage
    @chart_protected_areas = chart_protected_areas
    @global = global
  end

  def serialize
    {
      name: @habitat.name,
      theme: @habitat.theme,
      content: content,
      map: {
        habitatTitle: @habitat.title,
        habitatType: @habitat_type,
        theme: @habitat.theme,
        tables: [@habitat.poly_table, @habitat.point_table].compact,
        titleGlobal: @habitat.global_coverage_title(@habitat_type),
        titleProtected: @habitat.protected_title,
        percentageGlobal: @habitat.global_coverage,
        percentageProtected: @habitat.protected_percentage,
        wmsUrl: @habitat.wms_url
      },
      columnChart: @chart_greatest_coverage,
      rowChart: @chart_protected_areas,
      disclaimer: @global['disclaimer'],
      commitments: [
        aichi_targets, 
        sdgs,
        content['other_targets'] 
      ]
    }
  end

  private
  
  def content
    YAML.load(File.open("#{Rails.root}/lib/data/content/#{@habitat.name}.yml", 'r'))
  end

  def aichi_targets
    @aichi_targets = YAML.load(File.open("#{Rails.root}/lib/data/content/aichi-targets.yml", 'r'))
    generateImageUrls @aichi_targets
  end

  def sdgs
    @sdgs = YAML.load(File.open("#{Rails.root}/lib/data/content/sdgs.yml", 'r'))
    generateImageUrls @sdgs
  end

  def generateImageUrls targets
    targets['list'].each do |target|
      target.merge!({'icon': ActionController::Base.helpers.image_url(target['icon'])})
    end

    targets
  end
end
