# Main game init and loop
class Hangman
  def initialize
    @word = pick_random_line
    @guesses = []
    @guessed_word = '_' * @word.length
    @false_guesses = 0
    main
    puts @word
  end

  def main
    welcome
    puts @word
    loop do
      check_guess(get_guess)
    end
  end

  def welcome
    require 'io/console'
    win_width = IO.console.winsize[1]
    puts "#{'=' * win_width} "

    puts 'Welcome! Guess the word I am thinking and I will stop the execution.'
    puts
    puts "It has #{@word.length} letters".center(win_width)
    puts
    puts @guessed_word.center(win_width)
    puts
  end

  def get_guess
    loop do
      puts 'What letters are in this word?'
      guess = gets.chomp
      return guess if validate_guess(guess)
    end
  end

  def check_guess(guess)
    if @word.downcase.include?(guess.downcase)
      # casecmp compares two strings, case-insensitively
      # doesn't work
      indexes = (0...@word.length).find_all {
        |i| @word[i, 1].casecmp?(guess)
      }
      indexes.each do |i|
        @guessed_word[i] = guess.downcase
        puts @guessed_word
      end
    else
      @false_guesses += 1
      puts "#{@false_guesses} false guess(es)!"
    end
  end

  def validate_guess(guess)
    if guess.length > 1
      if guess.match?(/[A-Z]/i)
        puts 'You can only guess one letter at a time.'
      else
        puts 'Give me a letter from the alphabet.'
      end
      false
    elsif guess.match?(/[A-Z]/i)
      if @guesses.include?(guess)
        puts 'You have already guessed that letter.'
        puts
        false
      else
        @guesses << guess
        true
      end
    else
      puts 'Give me a letter from the alphabet.'
      puts
      false
    end
  end
  
  def check_victory
  end

  def pick_random_line
    File.readlines('assets/5desk.txt')
        .select { |word| (5..12).cover?(word.strip.length) }
        .sample
        .strip
  end
end

Hangman.new
