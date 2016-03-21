module RSA
  # Generates parameters for the RSA keypair
  class Generator
    def initialize(p, q, e: nil, d: nil)
      @p = p
      @q = q

      @e = e || find_e
      @d = d || find_d(@e)
    end

    def n
      p * q
    end

    def phi
      (p - 1) * (q - 1)
    end

    def encrypt(m)
      (m**@e) % n
    end

    def decrypt(c)
      (c**@d) % n
    end

    attr_reader :p, :q, :e, :d

    private

    def find_e
      loop do
        e = Random.rand(phi) + 1
        return e if phi.gcd(e) == 1
      end
    end

    def find_d(e)
      loop do
        d = Random.rand(phi) + 1
        return d if (e * d) % phi == 1
      end
    end
  end
end
