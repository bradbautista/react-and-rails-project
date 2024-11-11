require "test_helper"

class ScenariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scenario = scenarios(:one)
  end

  test "should get index" do
    get scenarios_url, as: :json
    assert_response :success
  end

  test "should create scenario" do
    assert_difference("Scenario.count") do
      post scenarios_url, params: { scenario: { created_at: @scenario.created_at, description: @scenario.description } }, as: :json
    end

    assert_response :created
  end

  test "should show scenario" do
    get scenario_url(@scenario), as: :json
    assert_response :success
  end

  test "should update scenario" do
    patch scenario_url(@scenario), params: { scenario: { created_at: @scenario.created_at, description: @scenario.description } }, as: :json
    assert_response :success
  end

  test "should destroy scenario" do
    assert_difference("Scenario.count", -1) do
      delete scenario_url(@scenario), as: :json
    end

    assert_response :no_content
  end
end
