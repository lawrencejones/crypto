require 'rspec'
require_relative './kasiski.rb'

RSpec.describe(Kasiski) do
  subject(:kasiski) { described_class.new(cipher_text) }

  # Uses a Vigenere cipher with key 'crypto'
  let(:cipher_text)  { File.read('./vigenere_cipher_text.fixture') }

  describe('.key_size') do
    it 'guesses key size of cipher used' do
      expect(kasiski.key_size).to equal(6)
    end
  end
end
