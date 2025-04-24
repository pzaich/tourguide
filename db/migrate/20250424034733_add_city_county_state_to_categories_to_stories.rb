class AddCityCountyStateToCategoriesToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :city, :string
    add_column :stories, :county, :string
    add_column :stories, :state, :string
    add_column :stories, :categories, :jsonb, default: []

    add_index :stories, :city
    add_index :stories, :county
    add_index :stories, :state
  end
end
