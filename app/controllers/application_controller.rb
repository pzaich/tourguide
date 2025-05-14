class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def ping
    render json: { status: "pong" }
  end

  def current_location
    @current_location ||= Geocoder.search(params[:coordinates]).first
    render json: @current_location
  end
end
