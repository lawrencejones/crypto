require 'set'

# Shared utility functions
module Utils
  def self.stream_cipher(text, &cipher)
    count = 0
    text.downcase.chars.map do |char|
      next(char) unless char =~ /[a-z]/

      cipher.call(char, count).tap { count += 1 }
    end.join
  end

  def self.pct_in_dictionary(text)
    words = text.downcase.gsub(/[^\sa-z]/, '').split
    words.count { |word| in_dictionary?(word) }.to_f / words.size
  end

  def self.in_dictionary?(word)
    dictionary.include?(word.downcase)
  end

  def self.dictionary
    @dictionary ||= Set.
      new(File.read('/usr/share/dictionary/words').split.map(&:downcase))
  end
end
