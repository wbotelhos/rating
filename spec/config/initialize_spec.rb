# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating::Config, 'initialize' do
  it 'has default models' do
    expect(subject.rate_model).to   eq '::Rating::Rate'
    expect(subject.rating_model).to eq '::Rating::Rating'
  end
end
