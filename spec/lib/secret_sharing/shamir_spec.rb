require 'secret_sharing/shamir'

RSpec.describe(SecretSharing::Shamir) do
  subject(:shamir) { described_class.new(secret, t: t, q: q) }

  let(:secret) { 87 }

  let(:q) { 101 } # Zp field
  let(:t) { 2 } # requires t+1 secrets for recovery
  let(:parties) { 1..7 }

  let(:shares) { shamir.shares(parties) }

  context 'with >t shares' do
    it 'recovers secret' do
      expect(shamir.recover_secret(shares.slice(2, 4, 6))).
        to eql(secret)
    end
  end

  context 'with <=t shares' do
    it 'does not recover secret' do
      expect(shamir.recover_secret(shares.slice(2, 4))).
        not_to eql(secret)
    end
  end
end
