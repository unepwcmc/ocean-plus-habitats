class Serializers::HabitatSpeciesCountSerializer < Serializers::Base

  def initialize (red_list_data)
    super(red_list_data, 'red_list_data')
  end

  def serialize
    species_count_by_id = {}
    
    @red_list_data.each do |habitat| 
      species_count_by_id[habitat[:id]] = habitat['data'] ? habitat['data'].last.last : 0
    end

    species_count_by_id
  end
end
