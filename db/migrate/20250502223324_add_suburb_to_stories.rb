class AddSuburbToStories < ActiveRecord::Migration[8.0]
  def change
    add_column :stories, :suburb, :string
    add_index :stories, :suburb
  end
end
