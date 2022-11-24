# frozen_string_literal: true

require 'io/console'
require 'pry-byebug'
require './char'
require './word'

class Cw
  include Constants

  QUIT = 'q'
  VALID_TOKENS = %w[. - q]

  attr_accessor :char, :time_delta, :time_deltas, :word, :words

  def initialize
    @char = Char.new  # current character tokens are being added to
    @time_delta = 0   # time since last token received
    @time_deltas = [] # all the time_deltas we have tracked
    @word = Word.new  # current word, characters are being added to
    @words = []       # the words we have seen
  end

  def translate
    t0 = nil
    loop do
      token = STDIN.getch
      next unless VALID_TOKENS.include?(token)

      if quitting?(token)
        finish_program
      end

      self.time_delta = [(t0 ? Time.now - t0 : 0), max_time_delta].min
      time_deltas << time_delta.round(2)
      if end_char?
        finish_character
        if end_word?
          finish_word
        end
      end
      char.add_token(token)

      print_status

      t0 = Time.now
    end
  end

  private

  def mean_time
    return 0 if time_deltas.empty?

    time_deltas.sum / time_deltas.size.to_f
  end

  def median_time
    return 0 if time_deltas.empty?

    midpoint = (time_deltas.size / 2.0).round
    time_deltas.sort[midpoint - 1]
  end

  def max_time_delta
    return 5 if median_time.zero?

    2.5 * median_time
  end

  def average_bottom_sample
    return 0 if time_deltas.empty?

    half_size = (time_deltas.size / 2.0).round
    time_deltas.sort.slice(0, half_size).sum / half_size.to_f
  end

  # whether to translate captured tokens into a character
  def end_char?
    puts "time_delta: #{time_delta}"
    puts "median_time: #{median_time}"

    time_delta > (median_time * 2)
  end

  # whether a word is ready to be captured
  def end_word?
    time_delta > (median_time * 3)
  end

  def finish_character
    char.translate
    word.add_character(char)
    self.char = Char.new
  end

  def finish_program
    finish_character
    finish_word
    print_status
    exit(0)
  end

  def finish_word
    words << word
    self.word = Word.new
  end

  def print_status
    system('clear')
    puts "Elapsed: #{time_delta}"
    puts "time_deltas: #{time_deltas.join(', ')}"
    puts "Words: #{words.map(&:to_s).join(' ')}"
    puts "Word: #{word}"
    puts "Char: #{char}"
  end

  def quitting?(token)
    token.eql?(QUIT)
  end
end

if $PROGRAM_NAME == __FILE__
  puts 'running program'
  system('clear')
  cw = Cw.new
  cw.translate
end
