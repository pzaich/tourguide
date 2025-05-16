class Story < ApplicationRecord
  include Rails.application.routes.url_helpers

  scope :relevant, -> (location:, categories: []) do
    where(city: location.city, county: location.county, state: location.state)
    .categories(categories: categories)
  end
  scope :categories, -> (categories: []) do
    categories.reduce(self) do |stories, category|
      stories.where(
        ActiveRecord::Base.sanitize_sql(
          "
            EXISTS (
              SELECT 1
              FROM json_each(stories.categories)
              WHERE value in (#{categories.map { |c| "'#{c}'" }.join(",")})
            )
          "
        )
      )
    end
  end

    has_one_attached :story_audio
    has_one_attached :story_image

    FEMALE_VOICE_ID = "56AoDkrOh6qfVPDXZ7Pt"
    MALE_VOICE_ID = "5e3JKXK83vvgQqBcdUol"

    def audio_url
      url_for(story_audio) if story_audio.present?
    end

    def image_url
      url_for(story_image) if story_image.present?
    end

    def pick_voice_id
      [FEMALE_VOICE_ID, FEMALE_VOICE_ID, FEMALE_VOICE_ID, MALE_VOICE_ID].sample
    end

    def generate_audio!
      client = ElevenLabs::Client.new
        audio_base64 = client.post("text-to-speech/#{pick_voice_id}", {
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

    def generate_image!
      client = OpenAI::Client.new
      response = client.images.generate(
        parameters: {
          prompt: "Using a 1950s poster style, create a poster based on the following theme. Do not include any text in the image: #{title}",
          model: "gpt-image-1",
          n: 1,
          size: "1024x1024", 
          quality: "low",
          output_format: "jpeg"
        }
      )

      if response.dig('data',0, 'b64_json').present?
        image_data = Base64.decode64(response.dig('data',0, 'b64_json'))
        create_temp_file(image_data) do |temp_file|
          self.story_image.attach(
            io: temp_file,
            filename: "story_#{id}.jpg",
            content_type: "image/jpeg"
          )
        end
        save!
      end
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
