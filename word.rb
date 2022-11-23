# frozen_string_literal: true

class Word
  attr_accessor :chars, :word

  def initialize
    @chars = []
  end

  def add_character(char)
    chars << char
  end

  def to_s
    chars.map(&:to_s).join
  end
end
