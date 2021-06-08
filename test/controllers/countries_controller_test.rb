require 'test_helper'

class CountriesControllerTest < ActionController::TestCase

  setup do
    @change_stat = change_stats(:standard_change_stat)
    @habitat = habitats(:mangroves)
  end

  test "#index should return a successful response" do
    #skip("skipping for now")
    get :index

    assert_response :success
  end
end
