class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def ping
    render json: { status: "pong" }
  end

  def current_location
    @current_location ||= Geocoder.search(params[:coordinates]).first
    render json: {
      city: @current_location.city,
      county: @current_location.county,
      state: @current_location.state,
      categories: @categories,
      suburb: @current_location.suburb
    }
  end
end
