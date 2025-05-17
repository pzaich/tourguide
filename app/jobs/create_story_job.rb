class CreateStoryJob < ApplicationJob
  queue_as :default

    def perform(title:, city:, suburb:, county:, state:, category:)
      story = OpenaiClient.new.chat(
          user_prompt: Prompts.get_story(title, city: city, suburb: suburb, county: county, state: state),
          system_prompt: Prompts::SYSTEM_PROMPT,
          model: :gpt_41
      )

        s = Story.create(
            title: story["title"],
            description: story["description"],
            body: story["story"],
            city: city,
            suburb: suburb,
            county: county,
            state: state,
            categories: story["categories"] | [ category ],
            model: :gpt_41
        )

        GenerateStoryImageJob.perform_later(s.id)
    end
end
