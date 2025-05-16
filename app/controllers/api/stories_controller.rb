class Api::StoriesController < ApplicationController
  def index
    location = Geocoder.search(params[:coordinates]).first
      stories = Story.relevant(location:, categories: params[:categories])
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

    def play
      story = Story.find(params[:id])
      story.generate_audio! if story.story_audio.blank?
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
            body: story.body,
            image_url: story.image_url
        }
      end
end
