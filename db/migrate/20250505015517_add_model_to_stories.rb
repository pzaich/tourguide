class AddModelToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :model, :string
    add_index :stories, :model
    Story.update_all(model: StoryRecommendations::MODELS[:gpt_41])
  end
end
