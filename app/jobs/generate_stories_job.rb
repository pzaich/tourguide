class GenerateStoriesJob < ApplicationJob
  queue_as :default

  def perform(city:, state:)
    location = Geocoder.search("#{city}, #{state}").first

    Prompts::CATEGORIES.each do |category|
      begin
        story_ideas = OpenaiClient.new.chat(
          user_prompt: Prompts.get_story_ideas(
            city: city,
            suburb: location.suburb,
            county: location.county,
            state: state,
          categories: [ category ]),
          system_prompt: Prompts::SYSTEM_PROMPT,
          model: :gpt_41_nano
        )
        story_ideas["stories"].each do |story_idea|
          CreateStoryJob.perform_later(
            title: story_idea,
            city: city,
            state: state,
            suburb: location.suburb,
            county: location.county,
            category: categories
          )
        end
      rescue => e
        puts "✗ Error generating stories for #{city}: #{e.message}"
      end
    end
  end
end
