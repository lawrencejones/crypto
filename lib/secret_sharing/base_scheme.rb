module SecretSharing
  # Provides interface for secret sharing schemes, as well as Base64 encoding
  # the initial secret.
  class BaseScheme
    def initialize(secret, recovery_groups)
      @secret = [secret].pack('m')
      @secret_size = @secret.unpack('B*').first.size
      @recovery_groups = Set.new(recovery_groups.map { |g| Set.new(g) })
    end

    def shares
      @shares ||= compute_shares
    end

    def recover_secret(*_shares)
      fail NotImplementedError
    end

    private

    attr_reader :secret, :secret_size, :recovery_groups

    def qualifying?(group)
      recovery_groups.any? { |recovery_group| recovery_group.subset?(Set.new(group)) }
    end

    def binify_share(share)
      [share.to_s(2).rjust(secret_size, '0')].pack('B*')
    end

    def generate_random_share
      SecureRandom.random_bytes(secret_size / 8).unpack('B*')[0].to_i(2)
    end

    def parties
      @parties = recovery_groups.inject(:+).freeze
    end
  end
end
