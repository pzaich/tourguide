if ENV["ELEVEN_LABS_API_KEY"].present?
    ElevenLabs.configure do |config|
        config.api_key = ENV.fetch("ELEVEN_LABS_API_KEY")
    end
end
