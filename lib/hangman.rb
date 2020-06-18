# Main game init and loop
class Hangman
  def initialize
    require 'io/console'
    @win_width = IO.console.winsize[1]
    @word = pick_random_line
    @guesses = []
    @guessed_word = Array.new(@word.length, '_')
    @false_guesses = 0
    main
  end

  def main
    puts "#{'=' * @win_width} "
    welcome
    loop do
      update_display
      check_guess(get_guess)
      break if victory?
      break if defeat?

      puts "#{'=' * @win_width} "
    end
  end

  def welcome
    puts 'Welcome! Guess the word I am thinking and I will stop the execution.'
    puts
    puts "It has #{@word.length} letters".center(@win_width)
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
      # takes 1 letter substrings from the word and looks for match
      # if match, add that to indexes array
      indexes = (0...@word.length).find_all {
        |i| @word[i, 1].casecmp?(guess)
      }
      # replace the '_' with the guessed letters
      indexes.each do |i|
        @guessed_word[i] = guess.downcase
      end
    else
      @false_guesses += 1
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

  def victory?
    if @guessed_word.join.downcase == @word.downcase
      puts
      puts 'Congratulations! You are a hero!'
      true
    else
      false
    end
  end

  def defeat?
    if @false_guesses >= 7
      puts "#{'=' * @win_width} "
      update_display
      puts 'Game over.'
      puts "The word was #{@word}"
      true
    else
      false
    end
  end

  def display_hangman
    puts File.read("assets/#{@false_guesses}false.txt")
  end

  def update_display
    display_hangman
    puts
    puts @guessed_word.join(' ')
    puts
    puts
    puts "Letters used: #{@guesses.join(',')}"
    puts "#{'_' * @win_width} "
  end

  def pick_random_line
    File.readlines('assets/5desk.txt')
        .select { |word| (5..12).cover?(word.strip.length) }
        .sample
        .strip
  end
end

Hangman.new
