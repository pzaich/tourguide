class StoryRecommendations
  def self.create(categories:, coordinates:, model: :gpt_41_nano)
    new(categories: categories, coordinates: coordinates, model: model).get_stories
  end

def initialize(categories:, coordinates:, model:)
  @location = Geocoder.search(coordinates).first
    @categories = categories
    @model = model
  end

  def client_model
    AI::MODELS[@model]
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def anthropic_client
    @anthropic_client ||= AnthropicClient.new
  end

  def client
    @client ||= anthropic? ? anthropic_client : openai_client
  end

  def anthropic?
    client_model.match?(AI::SONNET_3_7)
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
        client.chat(system_prompt: system_prompt, assistant_prompt: "[", user_prompt: user_prompt)
      else
        client.chat(system_prompt: system_prompt, user_prompt: user_prompt)
      end
    end
  end

  def get_stories
    first_10_story_ideas = chat.slice(0, 10)
    stories = Parallel.map(first_10_story_ideas, in_threads: 3) do |story_idea|=
      CreateStoryJob.perform_now(
        story_idea,
        city: @location.city,
        county: @location.county,
        state: @location.state,
        suburb: @location.suburb
      )
    end
    stories
  end
end
