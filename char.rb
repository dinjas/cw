# frozen_string_literal: true

require './constants'

class Char
  include Constants

  ERROR_SYMBOL = '<CharERR>'

  attr_accessor :char, :complete, :tokens

  def initialize
    @char = nil
    @complete = false
    @tokens = []
  end

  def add_token(token)
    tokens << token
  end

  def translate
    return true unless pending?

    self.char = CHAR_LOOKUP.fetch(tokens.join, '???')
    self.complete = true
  end

  def completed?
    complete
  end

  def pending?
    !completed? && tokens.any?
  end

  def to_s
    char || tokens.join
  end
end
