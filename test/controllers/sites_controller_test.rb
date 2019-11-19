require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "#index should return a successful response" do

    setup do
      @change_stat = change_stats(:standard_change_stat)
      @habitat = habitats(:mangroves)
    end

    get :index

    assert_response :success
  end
end
