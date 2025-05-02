class Story < ApplicationRecord
  include Rails.application.routes.url_helpers

    has_one_attached :story_audio

    VOICE_ID = "56AoDkrOh6qfVPDXZ7Pt"

    def audio_url
      url_for(story_audio)
    end

    def generate_audio!
      client = ElevenLabs::Client.new
        audio_base64 = client.post("text-to-speech/#{VOICE_ID}", {
            text: body,
            voice_settings: {
                stability: 0.63,
                similarity_boost: 0.25,
                style: 0.1,
                use_speaker_boost: true
            }
        })

        create_temp_file(audio_base64) do |temp_file|
          # Attach the file to Active Storage
          self.story_audio.attach(
              io: temp_file,
              filename: "story_#{id}.mp3",
              content_type: "audio/mpeg"
          )
        end

        save!
    end

    private

      def create_temp_file(audio_base64, &block)
        temp_file = Tempfile.new([ "audio", ".mp3" ])
          temp_file.binmode
          temp_file.write(audio_base64)
          temp_file.rewind

          block.call(temp_file)

          temp_file.close
          temp_file.unlink
      end
end
