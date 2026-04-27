# frozen_string_literal: true

RSpec.shared_context 'with database records' do
  let!(:category) { create(:category) }

  let!(:author_1) { create(:author) }
  let!(:author_2) { create(:author) }

  let!(:article_1) { create(:article) }
  let!(:article_2) { create(:article) }
  let!(:article_3) { create(:article) }

  let!(:rate_1) { create(:rating_rate, author: author_1, resource: article_1, value: 5) } # rubocop:disable RSpec/LetSetup
  let!(:rate_2) { create(:rating_rate, author: author_1, resource: article_2, value: 3) } # rubocop:disable RSpec/LetSetup
  let!(:rate_3) { create(:rating_rate, author: author_1, resource: article_3, value: 2) } # rubocop:disable RSpec/LetSetup
  let!(:rate_4) { create(:rating_rate, author: author_2, resource: article_1, value: 4) } # rubocop:disable RSpec/LetSetup

  let!(:rate_5) { create(:rating_rate, author: author_1, resource: article_1, scopeable: category, value: 1) } # rubocop:disable RSpec/LetSetup
  let!(:rate_6) { create(:rating_rate, author: author_2, resource: article_1, scopeable: category, value: 2) } # rubocop:disable RSpec/LetSetup
end
