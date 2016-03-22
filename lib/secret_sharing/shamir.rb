module SecretSharing
  # Shamir secret sharing for t+1 secret recovery
  class Shamir
    def initialize(secret, t:, q:)
      @secret = secret
      @t = t
      @q = q
    end

    def shares(parties)
      Hash[parties.each_with_index.map { |p, i| [i + 1, f(p)] }]
    end

    def recover_secret(shares)
      parties = shares.keys
      shares.map do |xi, si|
        recombinant_vector = (parties - [xi]).
          map { |xj| -xj * inverse(xi - xj) % @q }.
          inject(:*) % @q
        si * recombinant_vector
      end.inject(:+) % @q
    end

    private

    def f(x)
      co_efs.each_with_index.map { |co_ef, i| co_ef * (x**i) }.inject(:+) % @q
    end

    def co_efs
      @co_efs ||= [@secret, *Array.new(@t) { Random.rand(@q) }]
    end

    def inverse(x)
      field.find { |i| x * i % @q == 1 }
    end

    def field
      1..@q
    end
  end
end
