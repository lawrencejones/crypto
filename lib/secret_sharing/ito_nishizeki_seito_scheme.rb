require 'base64'
require 'securerandom'
require_relative './base_scheme'

module SecretSharing
  # Informationally secure secret sharing device.
  class ItoNishizekiSeitoScheme < BaseScheme
    # Standard XOR of all shares to recover secret. Very much like a one-time pad.
    def recover_secret(*shares)
      xor_binary = binify_share(shares.reduce { |a, e| a ^ e })
      xor_binary == secret ? Base64.decode64(xor_binary) : nil
    end

    private

    def compute_shares
      initial_shares = Hash[parties.map { |p| [p, []] }]

      recovery_groups.each_with_object(initial_shares) do |group, shares|
        random_shares = group.first(group.size - 1).map { |_| generate_random_share }
        det_share = random_shares.
          reduce(secret.unpack('B*').first.to_i(2)) { |a, e| a ^ e }

        group_shares = random_shares.concat([det_share])
        group_shares.zip(group).each { |share, party| shares[party].push(share) }
      end
    end
  end
end
