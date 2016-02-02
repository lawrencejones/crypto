class VigenereCipher
  def initialize(key)
    @key = key
  end

  def encode(plaintext)
    plaintext.chars.each_with_index.map do |char, i|
      transform(char, @key[i % @key.size])
    end.join
  end

  private

  def transform(char, base)
    chr((ord(char) + ord(base)) % 26)
  end

  def ord(char)
    char.ord - 'a'.ord
  end

  def chr(num)
    ('a'.ord + num).chr
  end
end
