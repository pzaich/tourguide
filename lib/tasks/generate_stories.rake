namespace :stories do
  desc "Generate stories for specific California cities"
  task generate: :environment do
    cities = [
      { name: "Los Angeles", coordinates: [ "34.0522", "-118.2437" ] },
      { name: "San Diego", coordinates: [ "32.7157", "-117.1611" ] },
      { name: "La Jolla", coordinates: [ "32.8328", "-117.2713" ] },
      { name: "Long Beach", coordinates: [ "33.7701", "-118.1937" ] }
    ]

    cities.each do |city|
      puts "Generating stories for #{city[:name]}..."
      begin
        GenerateStoriesJob.perform_later(city: city[:name], state: "CA")
      rescue => e
        puts "✗ Error generating stories for #{city[:name]}: #{e.message}"
      end
    end
  end
end
