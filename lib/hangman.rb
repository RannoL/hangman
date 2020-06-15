# Main game init and loop
class Hangman
  def initialize
    @word = pick_random_line
    p @word
  end

  def pick_random_line
    File.readlines('assets/5desk.txt')
        .select { |word| (5..12).cover?(word.strip.length) }
        .sample
        .strip
  end
end

Hangman.new
