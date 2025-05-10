class Api::StoryRecommendationsController < ApplicationController
  def create
    story_recommendations = StoryRecommendations.create(
      coordinates: params[:coordinates],
      categories: params[:categories],
      model: params[:model] || :gpt_41_nano
    )
      render json: story_recommendations
  end
end
