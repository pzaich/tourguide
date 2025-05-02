class Api::StoryRecommendationsController < ApplicationController
  def create
    story_recommendations = StoryRecommendations.create(coordinates: params[:coordinates], categories: params[:categories])
      render json: story_recommendations
  end
end
