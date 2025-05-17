module Ai
    GPT_41 = "gpt-4.1-2025-04-14"
    GPT_41_NANO = "gpt-4.1-nano-2025-04-14"
    SONNET_3_7 = "claude-3-7-sonnet-20250219"
  
    MODELS = {
      gpt_41: GPT_41,
      gpt_41_nano: GPT_41_NANO,
      sonnet_3_7: SONNET_3_7
    }.with_indifferent_access
end