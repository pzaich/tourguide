class OpenaiClient
  def initialize
    @client = OpenAI::Client.new
  end

  def chat(system_prompt:, user_prompt:, model: :gpt_41_nano)
    response = @client.chat(
        parameters: {
        model: Ai::MODELS[model],
        response_format: { type: "json_object" },
        messages: [
            { role: "system", content: system_prompt },
            { role: "user", content: user_prompt }
        ],
        temperature: 0.7
    })
    content = response.dig("choices", 0, "message", "content")
    JSON.parse(content)
  end
end
