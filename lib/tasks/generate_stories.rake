namespace :stories do
  desc "Generate stories for specific California cities"
  task generate: :environment do
    model = ENV.fetch("MODEL", :sonnet_3_7)
    cities = [
      { name: "Los Angeles", coordinates: [ "34.0522", "-118.2437" ] },
      { name: "San Diego", coordinates: [ "32.7157", "-117.1611" ] },
      { name: "San Jose", coordinates: [ "37.3382", "-121.8863" ] },
      { name: "San Francisco", coordinates: [ "37.7749", "-122.4194" ] },
      { name: "Fresno", coordinates: [ "36.7378", "-119.7871" ] },
      { name: "Sacramento", coordinates: [ "38.5816", "-121.4944" ] },
      { name: "Long Beach", coordinates: [ "33.7701", "-118.1937" ] },
      { name: "Oakland", coordinates: [ "37.8044", "-122.2712" ] },
      { name: "Anaheim", coordinates: [ "33.8366", "-117.9143" ] },
      { name: "Santa Ana", coordinates: [ "33.7455", "-117.8677" ] },
      { name: "Riverside", coordinates: [ "33.9806", "-117.3755" ] },
      { name: "Bakersfield", coordinates: [ "35.3733", "-119.0187" ] },
      { name: "Stockton", coordinates: [ "37.9577", "-121.2908" ] },
      { name: "Irvine", coordinates: [ "33.6846", "-117.8265" ] },
      { name: "Chula Vista", coordinates: [ "32.6401", "-117.0842" ] },
      { name: "Fremont", coordinates: [ "37.5485", "-121.9886" ] },
      { name: "San Bernardino", coordinates: [ "34.1083", "-117.2898" ] },
      { name: "Modesto", coordinates: [ "37.6391", "-120.9969" ] },
      { name: "Oxnard", coordinates: [ "34.1975", "-119.1771" ] },
      { name: "Fontana", coordinates: [ "34.0922", "-117.4350" ] }
    ]

    categories = [ "History", "Sports" ]

    cities.each do |city|
      puts "Generating stories for #{city[:name]}..."
      begin
        stories = StoryRecommendations.create(
          categories: categories,
          coordinates: city[:coordinates],
          model: model
        )
        puts "✓ Created #{stories.count} stories for #{city[:name]}"
      rescue => e
        puts "✗ Error generating stories for #{city[:name]}: #{e.message}"
      end
    end
  end
end
