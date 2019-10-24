require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
  test "#index should return a successful response" do
    get :index

    assert_response :success
  end
end
