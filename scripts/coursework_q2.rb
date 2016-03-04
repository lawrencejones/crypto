require 'digest'
require 'ecdsa'
require 'securerandom'

def digest(m)
  Digest::RMD160.digest(Digest::SHA256.digest(m))
end

def create_keypair(group)
  private_key = 1 + SecureRandom.random_number(group.order - 1)

  {
    private: private_key,
    public: group.generator.multiply_by_scalar(private_key),
  }
end

def normalize(digest, group)
  ECDSA.normalize_digest(digest, group.bit_length)
end

group = ECDSA::Group::Secp256k1
keypair = create_keypair(group)

u = 1 + SecureRandom.random_number(group.order - 1)

m1 = 'First message'
m2 = 'Second message'

h1 = digest(m1)
h2 = digest(m2)

s1 = ECDSA.sign(group, keypair[:private], digest(m1), u)
s2 = ECDSA.sign(group, keypair[:private], digest(m2), u)

point_field = ECDSA::PrimeField.new(group.order)

numerator = point_field.mod(normalize(h1, group) - normalize(h2, group))

puts(numerator: numerator, s1: s1, s2: s2)
