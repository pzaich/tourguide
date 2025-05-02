module Prompts
  def self.get_story_recommendations(city:, suburb:, county:, state:, categories:)
    system_prompt = <<~SYSTEM_PROMPT
            You are a tour guide. Your job is to offer a set of recommended stories to tell tourists visiting your area.
        SYSTEM_PROMPT

      user_prompt = <<~PROMPT
            You will be given a list of categories that the tourists are interested in.
            The tourists are visiting #{city} in #{county}, #{state}.
            Create a a series of story recommendations based on the following categories: #{categories.join(', ')}.

            Your job hinges on good story telling. Each story should be engaging, informative, and casual as if you were telling the story to a friend.
            Start by looking for stories that are relevant to the city, then broaden your search to include stories that are relevant to the county and surrounding cities.

            If the #{city} if larger in population than 300,000 people, neighborhoods in the city are sometimes of interest.
            You can share stories specific to the neighborhood as well. You are currently near the neighborhood: #{suburb}.

            The output should be a JSON array of objects, each containing the following fields:
            {
                "title": "The title of the story",
                "description": "A short description of the story (less than 20 words)",
                "categories": ["The categories that the story is about"]. Must be one of the following: #{categories.join(', ')},
                "story": "The story itself (300-500 words)"
            }
        PROMPT

      [ system_prompt, user_prompt ]
  end
end
