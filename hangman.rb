
class Hangman 
  def initialize(file='5desk.txt')
    @file = file
    @word_to_guess = get_random_word_from_file(@file)
    play_game
  end

  private

  def get_random_word_from_file(word_file)
    unless File.exists?(word_file)
      puts "The file: #{word_file} does not exist!"
      exit
    end
    word_list = File.read(word_file).split(/\r\n/)
    random_word = ''
    until random_word.length >= 5 && random_word.length <= 12
      random_word = word_list.sample
    end
    random_word
  end


  def get_character
    character = ''
    until character.match(/^[[:alpha:]]$/) || character == '1'
      begin
        system("stty raw -echo")
        character = STDIN.getc.upcase
      ensure
        system("stty -raw echo")
      end
    end
    puts character
    character
  end

  def play_game
    @misses = ''
    @word = ''
    @word_to_guess.length.times {@word << '-'}
    loop do
      puts "Debugging only ---> #{@word_to_guess}  <--- Debugging only"

      puts "Word: #{@word}     misses: #{@misses}"
      exit if @word == @word_to_guess.upcase 
      print "Guess: "
      guess_char = get_character
      exit if guess_char == '1'
      if @word_to_guess.upcase.include?(guess_char)
        # return array of all index positions of guess_char wihtin @word_to_guess
        a = (0 ... @word_to_guess.length).find_all { |i| @word_to_guess.upcase[i,1] == guess_char }
        a.each { |index| @word[index] = guess_char}
      else
        @misses << guess_char + ' ' unless @misses.include?(guess_char)
      end
      # puts "Word: #{@word}     Misses: #{@misses}"
      # puts guess_char
    end
  end

end

Hangman.new