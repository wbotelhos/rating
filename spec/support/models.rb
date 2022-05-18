# frozen_string_literal: true

Dir[File.expand_path('models/*.rb', __dir__)].each { |file| require file }
