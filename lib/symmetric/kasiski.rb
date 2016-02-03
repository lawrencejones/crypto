require 'pry'
require 'set'
require 'active_support/core_ext/hash'

class Kasiski
  def initialize(cipher_text)
    @cipher_text = cipher_text
  end

  def key_size
    @key_size ||= compute_key_size
  end

  private

  attr_reader :cipher_text

  def compute_key_size
    intervals = Set.new
    best_guess = nil

    common_ngrams(2).each do |(gram, _)|
      indexes = indexes_of(gram)

      indexes.first(indexes.size - 1).each_with_index do |n, i|
        intervals.add(indexes[i + 1] - n)
      end

      best_guess, p = gcd_probability(*intervals).max_by { |k, v| v }
      return best_guess if p > 0.5
    end

    best_guess
  end

  def indexes_of(substring)
    cipher_text.
      gsub(/\s/, ''). # remove all whitespace
      enum_for(:scan, substring).map { Regexp.last_match.begin(0) }
  end

  def gcd_probability(*ns)
    ns.product(ns).
      map { |(n, m)| n.gcd(m) unless n == m }.
      compact.
      each_with_object(count_hash) { |gcd, counts| counts[gcd] += 1 }.
      except(1).
      transform_values { |count| count.to_f / (ns.size * (ns.size - 1)) }
  end

  def common_ngrams(n)
    cipher_text.
      split.
      select { |word| word.size == n }.
      each_with_object(count_hash) { |ngram, counts| counts[ngram] += 1 }.
      sort_by { |_, count| -count }
  end

  def count_hash
    Hash.new.tap { |h| h.default = 0 }
  end
end
