if ENV["GROQ_API_KEY"].present?
  Groq.configure do |config|
    config.api_key = ENV["GROQ_API_KEY"]
    config.model_id = "deepseek-r1-distill-llama-70b"# #"meta-llama/llama-4-maverick-17b-128e-instruct"
  end
end
