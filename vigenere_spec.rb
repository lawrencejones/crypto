require 'rspec'
require_relative './vigenere'

RSpec.describe(VigenereCipher) do
  subject(:cipher) { described_class.new(key) }
  let(:key) { 'sesame' }

  describe('.encode') do
    it 'generates ciphertext' do
      expect(cipher.encode('thisisatestmessage')).
        to eql('llasuwsxwsfqwwkasi')
    end
  end
end
