# frozen_string_literal: true

module Rating
  class Config
    attr_accessor :rate_model, :rating_model

    def models(rate: nil, rating: nil)
      @rate_model   = rate   unless rate.nil?
      @rating_model = rating unless rating.nil?

      self
    end

    def initialize
      @rate_model   = ::Rating::Rate
      @rating_model = ::Rating::Rating
    end
  end
end
