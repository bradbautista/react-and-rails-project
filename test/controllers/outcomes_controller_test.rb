require "test_helper"

class OutcomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @outcome = outcomes(:one)
  end

  test "should get index" do
    get outcomes_url, as: :json
    assert_response :success
  end

  test "should create outcome" do
    / TODO mock service /
  end

  test "should show outcome" do
    get outcome_url(@outcome), as: :json
    assert_response :success
  end

  test "should update outcome" do
    patch outcome_url(@outcome), params: { outcome: { result: @outcome.result, scenario_id: @outcome.scenario_id } }, as: :json
    assert_response :success
  end

  test "should destroy outcome" do
    assert_difference("Outcome.count", -1) do
      delete outcome_url(@outcome), as: :json
    end

    assert_response :no_content
  end
end
