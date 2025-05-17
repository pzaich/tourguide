module Prompts
  CATEGORIES = [
    "history",
    "culture",
    "food",
    "art",
    "science",
    "technology",
    "nature",
    "celebrities",
    "sports",
    "kids",
    "crime",
    "politics",
    "paranormal"
  ]

  SYSTEM_PROMPT = <<~SYSTEM_PROMPT_TEXT
    You are a tour guide. Your job is to offer a set of recommended stories to tell tourists visiting your area.#{' '}

    Your job is to entertain your audience. You should be polite, friendly and a little funny. But it's also import to be truthful.#{' '}
    You could be FIRED for telling untruthful facts or stories to your audience.

  SYSTEM_PROMPT_TEXT

  def self.get_story_ideas(city:, suburb:, county:, state:, categories:)
    user_prompt = <<~PROMPT
      You will be given a list of categories that the tourists are interested in.
      The tourists are visiting #{city} in #{county}, #{state}.
      Create a a series of story ideas based on the following categories: #{categories.join(', ')}.#{' '}

      Try to make the story ideas as fun and engaging as possible. Create up to 20 story ideas.

      The output should be a valid JSON array of story titles.
    PROMPT
  end

  def self.get_story(title, city:, suburb:, county:, state:)
    user_prompt = <<~PROMPT
      The tourists are visiting #{city} in #{county}, #{state}.

      Your job hinges on good story telling. Your job is to tell a story using #{title} as the subject.
      
      YThe story should be engaging, informative. Your stories take on the narrative style of
      NPR (National Public Radio). The story should be 1000-1500 words long.

      The output should be a valid JSON object containing the following fields:
      #{get_story_recommendations_json_schema(CATEGORIES)}
    PROMPT
  end 

  def self.get_story_recommendations(city:, suburb:, county:, state:, categories:)
    user_prompt = <<~PROMPT
            You will be given a list of categories that the tourists are interested in.
            The tourists are visiting #{city} in #{county}, #{state}.
            Create a a series of story recommendations based on the following categories: #{categories.join(', ')}.

            Your job hinges on good story telling. Each story should be engaging, informative, and casual as if you were telling the story to a friend.
            Start by looking for stories that are relevant to the city, then broaden your search to include stories that are relevant to the county and surrounding cities.

            If the city is larger in population than 300,000 people, neighborhoods in the city are sometimes of interest.
            You can share stories specific to the neighborhood as well. You are currently near the neighborhood: #{suburb}.

            The output should be a valid JSON array of objects, each containing the following fields.
            #{get_story_recommendations_json_schema(categories)}
        PROMPT

      [ SYSTEM_PROMPT, user_prompt ]
  end

  def self.get_story_recommendations_json_schema(categories)
    <<~JSON_SCHEMA
      {
        "title": "The title of the story",
        "description": "A short description of the story (less than 20 words)",
        "categories": ["The categories that the story is about"]. Must be one of the following: #{categories.join(', ')},
        "story": "The story itself (1000-1500 words)"
      }
    JSON_SCHEMA
  end

  def self.get_continue_story(original_story)
    user_prompt = <<~PROMPT
      You just told the following story to your guests:

      #{original_story}

      Your guests really enjoyed your story. They'd like to hear more about the topic. You want to tell them
      an extended version that's 3-5 minutes long that builds on the original story you told. The story should be#{' '}
      approximately 1500 to 2000 words long.


      The output should be a JSON object, containing the following fields:
      {
          "title": "The title of the story",
          "description": "A short description of the story (less than 20 words)",
          "story": "The story itself (1500 to 2000 words)"
      }
    PROMPT
    [ SYSTEM_PROMPT, user_prompt ]
  end

  def self.get_related_stories(original_story, city:, state:, suburb:, categories:)
  end
end
