class StoryRecommendations
  GPT_41 = "gpt-4.1-2025-04-14"
  GPT_41_NANO = "gpt-4.1-nano-2025-04-14"
  SONNET_3_7 = "claude-3-7-sonnet-20250219"

  MODELS = {
    gpt_41: GPT_41,
    gpt_41_nano: GPT_41_NANO,
    sonnet_3_7: SONNET_3_7
  }.with_indifferent_access

  def self.create(categories:, coordinates:, model: :gpt_41_nano)
    new(categories: categories, coordinates: coordinates, model: model).get_stories
  end

def initialize(categories:, coordinates:, model:)
  @location = Geocoder.search(coordinates).first
    @categories = categories
    @model = model
  end

  def client_model
    MODELS[@model]
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def anthropic_client
    @anthropic_client ||= Anthropic::Client.new
  end

  def client
    @client ||= anthropic? ? anthropic_client : openai_client
  end

  def anthropic?
    client_model.match?(SONNET_3_7)
  end

  def chat
    system_prompt, user_prompt = Prompts.get_story_recommendations(
      city: @location.city,
      county: @location.county,
      state: @location.state,
      categories: @categories,
      suburb: @location.suburb
    )

    response = begin
      if anthropic?
        response = client.messages(
          parameters: {
            model: client_model,
            system: system_prompt,
            messages: [
              { "role": "user", "content": user_prompt },
              { "role": "assistant", "content": "[" }
            ],
            max_tokens: 10_000
          }
        )
        content =  JSON.parse("[" + response.dig("content", 0, "text"))
      else
        response = client.chat(
          parameters: {
            model: client_model,
            response_format: { type: "json_object" },
            messages: [
              { role: "system", content: system_prompt },
              { role: "user", content: user_prompt }
            ],
            temperature: 0.7
        })
        content = response.dig("choices", 0, "message", "content")
      end
    end
  end

  def get_stories
    max_10 = JSON.parse(chat)["stories"].slice(0, 10)
    stories = Parallel.map(max_10, in_threads: 3) do |story|
      Story.create(
        title: story["title"],
        description: story["description"],
        body: story["story"],
        city: @location.city,
        county: @location.county,
        state: @location.state,
        suburb: @location.suburb,
        categories: story["categories"],
        model: @model
      )
    end
    stories
  end
end
