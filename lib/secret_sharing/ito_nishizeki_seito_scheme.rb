require 'base64'
require 'securerandom'

module SecretSharing
  # Informationally secure secret sharing device.
  class ItoNishizekiSeitoScheme
    def initialize(secret, recovery_groups)
      @secret = [secret].pack('m')
      @secret_size = @secret.unpack('B*').first.size
      @recovery_groups = recovery_groups
    end

    def shares
      @shares ||= compute_shares
    end

    def recover_secret(*shares)
      xor_binary = binify_share(shares.reduce { |a, e| a ^ e })
      xor_binary == secret ? Base64.decode64(xor_binary) : nil
    end

    attr_reader :secret, :secret_size, :recovery_groups

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

    def binify_share(share)
      [share.to_s(2).rjust(secret_size, '0')].pack('B*')
    end

    def generate_random_share
      SecureRandom.random_bytes(secret_size / 8).unpack('B*')[0].to_i(2)
    end

    def parties
      recovery_groups.reduce([]) { |a, e| a.push(*e) }.uniq
    end
  end
end
