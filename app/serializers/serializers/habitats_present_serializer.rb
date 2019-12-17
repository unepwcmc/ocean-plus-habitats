class Serializers::HabitatsPresentSerializer < Serializers::Base
  include ApplicationHelper

  def initialize(habitat_presence_statuses, country_yml)
    super(country_yml, 'country_yml')
    super(habitat_presence_statuses, 'habitat_presence_statuses')
  end

  def serialize
    habitats.map do |habitat|
      id = habitat[:id].to_sym

      habitats_present = habitat.dup
      habitats_present[:status] = @habitat_presence_statuses[id]
      habitats_present[:status_title] = get_status_text(habitats_present[:status])
      habitats_present[:citation] = @country_yml[:habitats_present_citations][id]

      habitats_present
    end
  end

  def get_status_text status
    I18n.t("countries.shared.habitats_present.title_#{status}")
  end
end
