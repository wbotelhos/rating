# frozen_string_literal: true

RSpec.describe Rating::Extension, '#rating_warm_up' do
  context 'when record is author' do
    let!(:record) { build(:author) }

    it 'does not warm up the cache' do
      allow(record).to receive(:rating_warm_up)

      record.save

      expect(record).not_to have_received(:rating_warm_up)
    end
  end

  context 'when record is not author' do
    context 'when record has scoping' do
      let!(:record) { build(:article) }

      it 'warms up the cache' do
        allow(record).to receive(:rating_warm_up)

        record.save

        expect(record).to have_received(:rating_warm_up).with(scoping: :categories)
      end
    end

    context 'when record has no scoping' do
      let!(:record) { build(:comment) }

      it 'warms up the cache' do
        allow(record).to receive(:rating_warm_up)

        record.save

        expect(record).to have_received(:rating_warm_up).with(scoping: nil)
      end
    end

    context 'when update is made' do
      let!(:record) { create(:comment) }

      it 'does not warm up the cache' do
        allow(record).to receive(:rating_warm_up)

        record.save

        expect(record).not_to have_received(:rating_warm_up)
      end
    end
  end
end
