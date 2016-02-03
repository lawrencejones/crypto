require 'set'
require 'active_support/core_ext/hash'

# Implements a method of statistically analysing a cipher text to infer the size of the
# key used for a symmetric shift cipher.
class Kasiski
  def initialize(cipher_text)
    @cipher_text = cipher_text
  end

  def key_size
    @key_size ||= compute_key_size
  end

  private

  attr_reader :cipher_text

  # Finds the best guess for the size of the key used to encrypt the cipher text. The
  # threshold value specifies a minimum probability to accept for the guess confidence.
  def compute_key_size(threshold = 0.5)
    common_intervals(2).each do |intervals|
      best_guess, p = best_guess_key_size(intervals)

      return best_guess if p > threshold
    end

    nil
  end

  # Generates a set of interval values that appear between ngrams of size n in the
  # cipher text. Measures interval between closest neighbouring occurances.
  def common_intervals(n)
    Enumerator.new do |y|
      common_ngrams(n).each_with_object(Set.new) do |(gram), intervals|
        indexes = indexes_of(gram)
        indexes[0..-2].each_with_index { |m, i| intervals.add(indexes[i + 1] - m) }

        y << intervals
      end
      fail StopIteration
    end
  end

  # Finds the most likely shared divisor possible between all the intervals. Assumes that
  # the divisor will most likely be a size < 10.
  def best_guess_key_size(intervals)
    shared_divisors = possible_gcds(*possible_gcds(*intervals))

    frequency_distribution(shared_divisors).tap do |counts|
      return normalize(counts).max_by { |_k, v| v }
    end
  end

  # Computes the most commonly occuring ngrams of size n in the ciper_text
  def common_ngrams(n)
    cipher_text.
      split.
      select { |word| word.size == n }.
      each_with_object(count_hash) { |ngram, counts| counts[ngram] += 1 }.
      sort_by { |_, count| -count }
  end

  # Computes all possible greatest common divisors between every number. Excludes divisor
  # of 1.
  def possible_gcds(*ns)
    ns.product(ns).
      map { |(n, m)| n.gcd(m) unless n == m }.
      compact.
      select { |divisor| divisor > 1 }
  end

  # All zero-based indexes of substring within the cipher text
  def indexes_of(substring)
    cipher_text.
      gsub(/\s/, ''). # remove all whitespace
      enum_for(:scan, substring).map { Regexp.last_match.begin(0) }
  end

  def normalize(counts)
    total_count = counts.values.inject(:+)
    counts.transform_values { |count| count.to_f / total_count }
  end

  def frequency_distribution(values)
    values.each_with_object(count_hash) { |value, counts| counts[value] += 1 }
  end

  def count_hash
    {}.tap { |h| h.default = 0 }
  end
end
