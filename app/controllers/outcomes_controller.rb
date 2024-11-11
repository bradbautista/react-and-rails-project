class OutcomesController < ApplicationController
  before_action :set_outcome, only: %i[ show update destroy ]
  YES = 'yes'.freeze
  NO = 'no'.freeze

  # GET /outcomes
  def index
    @outcomes = Outcome.all

    render json: @outcomes
  end

  # GET /outcomes/1
  def show
    render json: @outcome
  end

  # POST /outcomes
  def create
    begin
      request_data = JSON.parse(request.body.read)
    rescue JSON::ParserError => e
      render json: { error: 'Invalid JSON in request body' }, status: :bad_request
      return
    end

    scenario = Scenario.find(request_data['scenarioId'])
    prompt = Prompt.where(prompt_type: 'outcome_prompt').first
    user_choice = request_data['choice']

    # do not trust userland, match request value to constant
    choice = (user_choice == YES || user_choice == NO) ? user_choice : NO

    client = OpenAI::Client.new(
        access_token: ENV['OPENAI_API_KEY'],
        organization_id: ENV['OPENAI_ORGANIZATION_ID']
    )

    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [
                { role: "system", content: "#{prompt.content} #{scenario.description}" },
                { role: "user", content: choice }
            ],
            temperature: 1.5,
        }
    )

    if response
      Rails.logger.info("OpenAI API Response: #{response.inspect}")
    else
      Rails.logger.info("No response from OpenAI API")
    end

    if response.dig("choices", 0, "message", "content").present?
      outcome = Outcome.create(result: response.dig("choices", 0, "message", "content"), scenario_id: scenario.id)
      render json: outcome, status: :created
    else
      render json: { error: 'Failed to generate outcome content.' }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /outcomes/1
  def update
    if @outcome.update(outcome_params)
      render json: @outcome
    else
      render json: @outcome.errors, status: :unprocessable_entity
    end
  end

  # DELETE /outcomes/1
  def destroy
    @outcome.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outcome
      @outcome = Outcome.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def outcome_params
      params.expect(outcome: [ :result, :scenario_id ])
    end
end
