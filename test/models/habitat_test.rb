require 'test_helper'

class HabitatTest < ActiveSupport::TestCase

  setup do
    @change_stat = change_stats(:standard_change_stat)
    @habitat = habitats(:mangroves)
  end

  test "calculate_country_cover_change" do
    skip("skipping for now")
    assert_equal true, false
  end

  test "calculate_global_cover_change" do
    skip("skipping for now")
    assert_equal true,false
  end
end