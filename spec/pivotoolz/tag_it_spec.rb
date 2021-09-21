require 'spec_helper'

require_relative '../../lib/pivotoolz/tag_it'

RSpec.describe TagIt do
  subject(:test!) { described_class.call(tag) }

  describe 'when tag is nil' do
    let(:tag) { nil }

    it 'does nothing' do
      expect(Kernel).not_to receive(:system)
      test!
    end
  end

  describe 'when tag is empty' do
    let(:tag) { '' }

    it 'does nothing' do
      expect(Kernel).not_to receive(:system)
      test!
    end
  end

  describe 'when tag is provided' do
    let(:tag) { 'some-tag' }

    it "calls git tag with 'TAG/TIMESTAMP'" do
      timestamp = '20210921050829'
      expect(Kernel).to receive(:system).with("date -u +'%Y%m%d%H%M%S'") { timestamp }
      expect(Kernel).to receive(:system).with("git tag #{tag}/#{timestamp}")
      expect(Kernel).to receive(:system).with("git push origin #{tag}/#{timestamp}")
      test!
    end
  end
end
