class StoryRecommendations
  include Groq::Helpers

  def self.create(categories:, coordinates:)
    new(categories: categories, coordinates: coordinates).get_stories
  end

def initialize(categories:, coordinates:)
    @location = Geocoder.search(coordinates).first
    @categories = categories
  end

  def client
    @client ||= OpenAI::Client.new
  end

  def get_stories
    system_prompt, user_prompt = Prompts.get_story_recommendations(
      city: @location.city,
      county: @location.county,
      state: @location.state,
      categories: @categories
    )
    response = client.chat(
      parameters: {
        model: "gpt-4.1-2025-04-14",
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: user_prompt }
        ],
        temperature: 0.7
    })
    content = response.dig("choices", 0, "message", "content")
    top_3 = JSON.parse(content)["stories"].slice(0, 3)
    stories = Parallel.map(top_3, in_threads: 3) do |story|
      s = Story.create(
        title: story["title"],
        description: story["description"],
        body: story["story"],
        city: @location.city,
        county: @location.county,
        state: @location.state,
        categories: story["categories"]
      )
      s.generate_audio!
      s
    end
    stories
  end
end
