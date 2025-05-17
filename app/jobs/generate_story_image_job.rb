class GenerateStoryImageJob < ApplicationJob
  queue_as :default

  def perform(story_id)
    story = Story.find(story_id)
    story.generate_image!
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Story not found for ID: #{story_id}"
  end
end
