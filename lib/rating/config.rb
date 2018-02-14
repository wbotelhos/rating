# frozen_string_literal: true

module Rating
  class Config
    def config
      @config ||= begin
        file_path = File.expand_path('config/rating.yml')

        return {} unless File.exist?(file_path)

        YAML.safe_load(File.read(file_path))['rating']
      end
    end

    def rate_table
      @rate_table ||= config[__method__.to_s] || 'rating_rates'
    end

    def rating_table
      @rating_table ||= config[__method__.to_s] || 'rating_ratings'
    end
  end
end
