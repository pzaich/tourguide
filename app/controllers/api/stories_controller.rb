class Api::StoriesController < ApplicationController
  def index
    location = Geocoder.search(params[:coordinates]).first
      stories = Story.where(city: location.city, county: location.county, state: location.state)
      params[:categories].each do |category|
        stories.where('categories LIKE ?', category)
      end
      render json: stories.map { |story| serialize_story(story) }
  end

    def show
      story = Story.find(params[:id])
        render json: serialize_story(story)
    end

    def create
      story = Story.create(story_params)
        story.generate_audio!
        render json: serialize_story(story)
    end

    private

      def serialize_story(story)
        {
            id: story.id,
            title: story.title,
            description: story.description,
            audio_url: story.audio_url,
            city: story.city,
            county: story.county,
            state: story.state,
            categories: story.categories,
            body: story.body
        }
      end
end
