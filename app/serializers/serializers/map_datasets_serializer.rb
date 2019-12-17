class Serializers::MapDatasetsSerializer < Serializers::Base
  include ApplicationHelper

  def initialize(habitat_presence_statuses, datasets)
    super(datasets, 'datasets')
    super(habitat_presence_statuses, 'habitat_presence_statuses')
  end

  def serialize
    map_datasets = @datasets.reject {|ds| habitat_presence_status(ds) == 'absent'}

    map_datasets.map do |ds| 
      dataset = ds.dup
      dataset[:name] = get_habitat_from_id(ds[:id])[:title]

      if habitat_presence_status(ds) == 'unknown' 
        dataset[:disabled] = true
        dataset[:descriptionHtml] = not_available_dataset_html
      end

      dataset
    end
  end

  private

  def habitat_presence_status dataset
    @habitat_presence_statuses[dataset[:id].to_sym]
  end

  def not_available_dataset_html
    '<p>Not available</p>'
  end
end
