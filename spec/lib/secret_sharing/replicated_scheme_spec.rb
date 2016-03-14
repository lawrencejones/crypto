require 'secret_sharing/replicated_scheme'

RSpec.describe(SecretSharing::ReplicatedScheme) do
  subject(:scheme) { described_class.new(secret, recovery_groups) }

  let(:secret) { 'my-super-secret' }
  let(:recovery_groups) { [%i(p g), %i(g s v)] }

  let(:shares) { scheme.shares }

  describe '.maximally_non_qualifying' do
    subject(:mnq) { scheme.maximally_non_qualifying }

    it { is_expected.to include(Set.new(%i(p s v))) }
    it { is_expected.to include(Set.new(%i(g s))) }
    it { is_expected.to include(Set.new(%i(g v))) }
  end

  describe '.recover_secret' do
    it 'succeeds with sufficient shares' do
      expect(scheme.recover_secret(shares[:p], shares[:g])).to eql(secret)
    end

    it 'returns nil for insufficient shares' do
      expect(scheme.recover_secret(shares[:p][0], shares[:g])).to be(nil)
    end
  end
end
