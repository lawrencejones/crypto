require 'secret_sharing/ito_nishizeki_seito_scheme'

RSpec.describe(SecretSharing::ItoNishizekiSeitoScheme) do
  subject(:ito) { described_class.new(secret, recovery_groups) }

  let(:secret) { 'my-super-secret' }
  let(:recovery_groups) { [%i(p g), %i(g s v)] }

  let(:shares) { ito.shares }

  describe '.recover_secret' do
    it 'succeeds with sufficient shares' do
      expect(ito.recover_secret(shares[:p][0], shares[:g][0])).to eql(secret)
    end

    it 'returns nil for insufficient shares' do
      expect(ito.recover_secret(shares[:p][0], shares[:s][0])).to be(nil)
    end
  end
end
