if ENV["ANTHROPIC_API_KEY"].present?
  Anthropic.configure do |config|
    # With dotenv
    config.access_token = ENV.fetch("ANTHROPIC_API_KEY")
    config.log_errors = Rails.env.development?
  end
end

class Anthropic::Client
  alias_method :chat, :messages
end
