class Serializers::TargetsSerializer < Serializers::Base
  include ApplicationHelper

  def initialize
    @target_tabs = I18n.t('countries.shared.targets.tabs')
  end

  def serialize
    @target_tabs[2][:list].each do |habitat| 
      habitat[:title] = get_habitat_from_id(habitat[:id])[:title]
    end

    @target_tabs
  end
end

