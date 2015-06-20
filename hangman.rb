require 'yaml'
class Hangman 
  def initialize(file='5desk.txt')
    @file = file
    @word_to_guess = get_random_word_from_file(@file)
    @misses = ''
    @word = ''
    @word_to_guess.length.times {@word << '-'}

    play_game
  end

  private

  def save_game
    data = [@word_to_guess, @word, @misses]
    filename = rand(10000).to_s

    while File.exist?(filename)
      filename = rand(10000).to_s
    end

    filename = "hangman#{filename}.yaml"

    File.open(filename, "w"){ |somefile| somefile.puts YAML.dump(data)}

    puts "File #{filename} created"

    exit
  end

  def quit_and_or_save
    print 'Do you want to save the current game (y/n)? '
    if get_character == 'Y'
      save_game
    else
      exit
    end
  end

  def get_random_word_from_file(word_file)
    # Loads the file and returns a random word betwee 5 and 12 characters
    unless File.exist?(word_file)
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
    # gets a character from the keyboard without pressing return
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
    loop do
      puts "Debugging only ---> #{@word_to_guess}  <--- Debugging only" if $VERBOSE

      puts "Word: #{@word}     misses (6 allowed): #{@misses}"
      if @word == @word_to_guess.upcase 
        puts "You win! You correctly guessed that the word is #{@word_to_guess.upcase}"
        exit
      elsif @misses.length >= 12
        puts 'You lose!'
        puts "The word was #{@word_to_guess.upcase}"
        exit
      end
      print "Guess: "
      guess_char = get_character
      if guess_char == '1'
        print 'Are you sure you want to quit? (y/n)? '
        if get_character == 'Y'
          quit_and_or_save
        else
          next
        end
      elsif @word_to_guess.upcase.include?(guess_char)
        # return array of all index positions of guess_char wihtin @word_to_guess
        (0 ... @word_to_guess.length).find_all { |i| @word_to_guess.upcase[i,1] == guess_char }.each { |index| @word[index] = guess_char}
      else
        @misses << guess_char + ' ' unless @misses.include?(guess_char)
      end
    end
  end

end

Hangman.new