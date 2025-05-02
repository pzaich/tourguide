namespace :stories do
  desc "Generate stories for specific California cities"
  task generate: :environment do
    cities = [
      { name: "Long Beach", coordinates: "33.7701,-118.1937" },
      { name: "San Diego", coordinates: "32.7157,-117.1611" },
      { name: "La Jolla", coordinates: "32.8328,-117.2713" }
    ]
    
    categories = ["History", "Sports"]
    
    cities.each do |city|
      puts "Generating stories for #{city[:name]}..."
      begin
        stories = StoryRecommendations.create(
          categories: categories,
          coordinates: city[:coordinates]
        )
        puts "✓ Created #{stories.count} stories for #{city[:name]}"
      rescue => e
        puts "✗ Error generating stories for #{city[:name]}: #{e.message}"
      end
    end
  end
end 