require './lookup_constants'

class Morse
  include LookupConstants

  attr_reader :

  def initialize
    @
  end

  def run
    char_gap = 0
    word_gap = 0
    t1 = now
    while char = gets.chomp
      unless VALID_CHARS.include?(char)
        puts "invalid character: #{char}"
        next
      end

      puts "got #{char}"
      elapsed = now - t1
      puts "elapsed: #{elapsed}"
      adjust_timing(elapsed)
      t1 = now
    end
  end

  private

  def now
    Time.now
  end
end
if $PROGRAM_NAME == __FILE__
  puts 'running program'
  m = Morse.new
  m.run
end
