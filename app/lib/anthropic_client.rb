class AnthropicClient
  def initialize
    @client = Anthropic::Client.new
  end

  def chat(system_prompt:, assistant_prompt: nil, user_prompt:, model: :sonnet_3_7)
    response = @client.messages(
          parameters: {
            model: Ai::MODELS[model],
            system: system_prompt,
            messages: [
              { "role": "user", "content": user_prompt },
              { "role": "assistant", "content": assistant_prompt }
            ],
            max_tokens: 10_000
          }
        )
    JSON.parse(assistant_prompt + response.dig("content", 0, "text"))
  end
end
