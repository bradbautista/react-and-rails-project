class ScenariosController < ApplicationController
  before_action :set_scenario, only: %i[ show update destroy ]

  # GET /scenarios
  def index
    @scenarios = Scenario.all

    render json: @scenarios
  end

  # GET /scenarios/1
  def show
    render json: @scenario
  end

  # POST /scenarios
  def create
    @prompt = Prompt.find_by(prompt_type: "scenario_prompt")

    client = OpenAI::Client.new(
      access_token: ENV["OPENAI_API_KEY"],
      organization_id: ENV["OPENAI_ORGANIZATION_ID"]
    )

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [ { role: "system", content: @prompt.content } ],
        temperature: 1.5
      }
    )

    # if there is a response, logs the response; if not, logs something saying no response
    if response
      Rails.logger.info("OpenAI API Response: #{response.inspect}")
    else
      Rails.logger.info("No response from OpenAI API")
    end

    # Extract and create scenario only if response contains valid data
    if response.dig("choices", 0, "message", "content").present?
      scenario = Scenario.create(description: response.dig("choices", 0, "message", "content"))
      render json: scenario, status: :created
    else
      render json: { error: "Failed to generate scenario content" }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error("Error in OpenAI API call: #{e}")
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end

  # PATCH/PUT /scenarios/1
  def update
    if @scenario.update(scenario_params)
      render json: @scenario
    else
      render json: @scenario.errors, status: :unprocessable_entity
    end
  end

  # DELETE /scenarios/1
  def destroy
    @scenario.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scenario
      @scenario = Scenario.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def scenario_params
      params.expect(scenario: [ :created_at, :description ])
    end
end
