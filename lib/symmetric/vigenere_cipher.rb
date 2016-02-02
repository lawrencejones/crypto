require_relative '../utils'

class VigenereCipher
  def initialize(key)
    @key = key
  end

  def encode(plaintext)
    Utils.stream_cipher(plaintext) do |char, i|
      chr((ord(char) + ord(@key[i % @key.size])) % 26)
    end
  end

  private

  def ord(char)
    char.ord - 'a'.ord
  end

  def chr(num)
    ('a'.ord + num).chr
  end
end
