require 'rspec'
require_relative '../../lib/symmetric/kasiski'

RSpec.describe(Kasiski) do
  subject(:kasiski) { described_class.new(cipher_text) }

  # Uses a Vigenere cipher with key 'crypto'
  let(:cipher_text)  { load_fixture('sample.vigenere.encrypted') }

  describe('.key_size') do
    it 'guesses key size of cipher used' do
      expect(kasiski.key_size).to equal(6)
    end
  end
end
