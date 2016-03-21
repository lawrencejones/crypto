require 'rsa/generator'

RSpec.describe(RSA::Generator) do
  subject(:generator) { described_class.new(p, q) }

  let(:p) { 13 }
  let(:q) { 97 }

  let(:private_key) { generator.private_key }
  let(:public_key) { generator.public_key }

  let(:message) { 7 }

  it 'decrypt(encrypt(p)) == p' do
    expect(generator.decrypt(generator.encrypt(message))).to eql(message)
  end
end
