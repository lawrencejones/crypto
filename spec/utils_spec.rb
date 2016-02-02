require 'rspec'
require_relative '../lib/utils'

RSpec.describe(Utils) do
  before { allow(Utils).to receive(:dictionary).and_return(Set.new(%w(sheep dog cat mouse))) }

  describe('.stream_cipher') do
    let(:plain_text) { 'white  , space ' }

    it 'preserves whitespace and punctuation' do
      Utils.stream_cipher(plain_text) { |char, i| char }.tap do |result|
        expect(result).to eql(plain_text)
      end
    end

    it 'provides cipher with correct indexes' do
      indexes = []
      Utils.stream_cipher(plain_text) { |char, i| indexes.push(i) }

      expect(indexes).to match_array(*[0..9])
    end

    it 'computes next character using cipher' do
      Utils.stream_cipher(plain_text) { |char, i| 'a' }.tap do |result|
        expect(result).to eql('aaaaa  , aaaaa ')
      end
    end
  end

  describe('.pct_in_dictionary') do
    it 'calculates percentage as a float' do
      expect(Utils.pct_in_dictionary('sheep dog called mike')).to be(0.5)
    end

    it 'ignores case' do
      expect(Utils.pct_in_dictionary('ShEeP DoG called mike')).to be(0.5)
    end

    it 'ignores punctuation' do
      expect(Utils.pct_in_dictionary('sheep dog, called mike')).to be(0.5)
    end
  end
end
