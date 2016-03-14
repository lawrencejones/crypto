require 'set'
require 'base64'
require 'securerandom'
require_relative './base_scheme'

module SecretSharing
  # Replicated secret sharing scheme
  class ReplicatedScheme < BaseScheme
    def recover_secret(*shares)
      xor_binary = binify_share(shares.flatten.reduce { |a, e| a ^ e })
      xor_binary == secret ? Base64.decode64(xor_binary) : nil
    end

    def maximally_non_qualifying
      @mnq ||= compute_maximally_non_qualifying.freeze
    end

    private

    def compute_maximally_non_qualifying(base_group = Set.new)
      next_non_qualifying = (parties - base_group).
        map { |party| base_group + [party] }.
        reject { |group| qualifying?(group) }

      return [base_group] if next_non_qualifying.empty?

      next_non_qualifying.
        map { |group| compute_maximally_non_qualifying(group) }.
        inject(Set.new, :+)
    end

    def compute_shares
      shares = Array.new(maximally_non_qualifying.size) { generate_random_share }
      shares.pop # remove last random
      shares << (shares.inject(0, :^) ^ secret.unpack('B*').first.to_i(2))

      maximally_non_qualifying.zip(shares).
        each_with_object({}) do |(mnq, share), party_shares|
          b = parties - mnq
          b.each { |party| party_shares[party] = [*party_shares[party], share] }
        end
    end
  end
end
