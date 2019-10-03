# frozen_string_literal: true

module Rating
  module Config
    module_function

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

    def validations
      @validations ||= begin
        default_scope = %w[author_type resource_id resource_type scopeable_id scopeable_type]

        {
          rate: {
            case_sensitive: config.dig('validations', 'rate', 'case_sensitive') || false,
            scope:          config.dig('validations', 'rate', 'scope') || default_scope,
          },
        }.deep_stringify_keys
      end
    end
  end
end
